extends Node

const SAVE_FOLDER := 'user://saves/'
const SLOT_COUNT := 3

signal game_loaded

func _ready():
	#Create save folder in folder dir location
	if !DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_absolute(SAVE_FOLDER)


		
func _save_player(player):
	return {
		'position': player.global_position,
		'inventory': player.inventory.slots.map(func(slot): return {
			'path': slot.item.resource_path if slot.item else '',
			'amount': slot.amount,
		})
	}
	
func _load_player(player, data):
	player.global_position = data.position
	
	## Clear all items before loading previously saved inventory.
	#player.inventory.items.clear()
	
	var slots = player.inventory.slots
	for i in range(slots.size()):
		var entry = data.inventory[i] if i <  data.inventory.size() else null
		if entry and entry.path != '':
			slots[i].item = load(entry.path)
			slots[i].amount = entry.amount
		else:
			slots[i].item = null
			slots[i].amount = 0
		
	player.inventory.update.emit()
	
func save_game(slot: int) -> void:	
	print("Saving slot ", slot, " to: ", ProjectSettings.globalize_path(SAVE_FOLDER))
	# Find player node.
	var player = get_tree().get_first_node_in_group('player')
	
	#Bundle player and time into dict:
	var data = {
		'player': _save_player(player), #pos + inv from _save_player func
		'time': {
			'day' : DayNightCycle.day,
			'hour' : DayNightCycle.hour,
			'minute' : DayNightCycle.minute,
		},
		'money': Economy.get_bal(),
		'saved_at': Time.get_datetime_string_from_system(),
	}
	
	# Open/Create file for  slot (e.g., user://saves/slot1.save.
	var file = FileAccess.open(SAVE_FOLDER + "slot_%d.save" % slot, FileAccess.WRITE)
	
	if file == null:
		push_error('Save failed: %s' % FileAccess.get_open_error())
		return
		
	# Write dict to file.
	file.store_var(data)

func load_game(slot: int) -> void:
	var path = SAVE_FOLDER + "slot_%d.save" % slot
	
	# Return if there's no save in this slot.
	if not FileAccess.file_exists(path):
		push_error('No save file at %s')
		return
		
	# Open file for reading.
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error('Load failed: %s' % FileAccess.get_open_error())
		return
		
	var data = file.get_var()
	
	# Find player.
	var player = get_tree().get_first_node_in_group('player')
	_load_player(player, data.player)
	
	game_loaded.emit()

func delete_save_slot(slot: int) -> void:
	var path = SAVE_FOLDER + 'slot_%d.save' % slot
	
	# Nothing to delete if file has no save
	if not FileAccess.file_exists(path):
		push_warning('No Saves to delete in this slot: %d' % slot)
	
	var err = DirAccess.remove_absolute(path)
	if err != OK:
		push_error('Delete failed for slot %d (error %d)' % [slot, err])
		
	print('Deleting Slot_%d.' % slot)


# Checks all 3 slots to see if it exists.
func slot_exists(slot: int) -> bool:
	return FileAccess.file_exists(SAVE_FOLDER + 'slot_%d.save' % slot)

# Read slot's saved dictionary.
func read_slot(slot: int) -> Dictionary:
	var file = FileAccess.open(SAVE_FOLDER + 'slot_%d.save' % slot, FileAccess.READ)	
	return file.get_var() if file else {}
	
