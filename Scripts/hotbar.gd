extends HBoxContainer

@onready var inventory: Inventory = preload('res://inventory/player_inventory.tres')

const SLOT_SCENE = preload('res://Scenes/hotbar_slot.tscn')
const SLOT_COUNT = 9

var slots: Array[TextureButton] = []
var selected_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(SLOT_COUNT):
		var slot = SLOT_SCENE.instantiate()
		slot.index = i
		slot.pressed.connect(_on_slot_pressed.bind(i))
		add_child(slot)
		slots.append(slot)
	select_slot(0)
	inventory.update.connect(UpdateSlots)
	UpdateSlots()

func UpdateSlots() -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventKey and event.pressed and not event.echo:
			if event.keycode >= KEY_1 and event.keycode <= KEY_9:
				var idx = event.keycode - KEY_1
				select_slot(idx)
			elif event.keycode == KEY_0:
				select_slot(9-1) # or SLOT COUNT - 1 if 0 = last slot

func _on_slot_pressed(i:int) -> void:
	select_slot(i)
	
func select_slot(i:int) -> void:
	if i < 0  or i >= slots.size():
		return
	print("selecting slot ", i)
	slots[selected_index].set_selected(false)
	selected_index = i
	slots[selected_index].set_selected(true)
