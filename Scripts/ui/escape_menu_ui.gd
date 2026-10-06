extends CanvasLayer

@onready var save_slots_h_box: HBoxContainer = $EscapeMenu/MenuBackdrop/SaveSlotsHBox
@onready var escape_v_box: VBoxContainer = $EscapeMenu/MenuBackdrop/EscapeVBox

# Escape Menu.
@onready var options_button: TextureButton = $EscapeMenu/MenuBackdrop/EscapeVBox/OptionsButton
@onready var awards_button: TextureButton = $EscapeMenu/MenuBackdrop/EscapeVBox/AwardsButton
@onready var saves_button: TextureButton = $EscapeMenu/MenuBackdrop/EscapeVBox/SavesButton
@onready var exit_button: TextureButton = $EscapeMenu/MenuBackdrop/EscapeVBox/ExitButton
@onready var return_button: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ReturnButton
@onready var overwrite_button: TextureButton = $EscapeMenu/WarningPanelBackdrop/MarginContainer/WarningPanel/MarginContainer/VBoxContainer/HBoxContainer/OverwriteButton

# Overwrite/Delete failsafe popup.
@onready var warning_panel_backdrop: PanelContainer = $EscapeMenu/WarningPanelBackdrop
@onready var warning_message: Label = $EscapeMenu/WarningPanelBackdrop/MarginContainer/WarningPanel/MarginContainer/VBoxContainer/WarningMessage
@onready var delete_button: TextureButton = $EscapeMenu/WarningPanelBackdrop/MarginContainer/WarningPanel/MarginContainer/VBoxContainer/HBoxContainer/DeleteButton
@onready var cancel_button: TextureButton = $EscapeMenu/WarningPanelBackdrop/MarginContainer/WarningPanel/MarginContainer/VBoxContainer/HBoxContainer/CancelButton

# Empty Save Slot	s.
@onready var empty_save_slot_button_1: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/EmptySaveSlot1/MarginContainer/HBoxContainer/EmptySaveSlotButton1
@onready var empty_save_slot_button_2: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/EmptySaveSlot2/MarginContainer/HBoxContainer/EmptySaveSlotButton2
@onready var empty_save_slot_button_3: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/EmptySaveSlot3/MarginContainer/HBoxContainer/EmptySaveSlotButton3

@onready var overwrite_button_1: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel1/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/OverwriteButton1
@onready var overwrite_button_2: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel2/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/OverwriteButton2
@onready var overwrite_button_3: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel3/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/OverwriteButton3

@onready var load_save_button_1: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel1/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/LoadSaveButton1
@onready var load_save_button_2: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel2/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/LoadSaveButton2
@onready var load_save_button_3: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel3/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/LoadSaveButton3

@onready var empty_save_slot_1: TextureRect = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/EmptySaveSlot1
@onready var empty_save_slot_2: TextureRect = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/EmptySaveSlot2
@onready var empty_save_slot_3: TextureRect = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/EmptySaveSlot3

@onready var save_slot_panel_1: TextureRect = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel1
@onready var save_slot_panel_2: TextureRect = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel2
@onready var save_slot_panel_3: TextureRect = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel3

@onready var delete_save_button_1: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel1/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/DeleteSaveButton1
@onready var delete_save_button_2: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel2/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/DeleteSaveButton2
@onready var delete_save_button_3: TextureButton = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/SaveSlotPanel3/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer2/HBoxContainer/DeleteSaveButton3

@onready var filled_panels = [save_slot_panel_1, save_slot_panel_2, save_slot_panel_3]
@onready var empty_panels = [empty_save_slot_1, empty_save_slot_2, empty_save_slot_3]

@onready var escape_menu: Control = $EscapeMenu
@onready var game_time: Label = %GameTime
@onready var line_edit: LineEdit = $EscapeMenu/MenuBackdrop/SaveSlotsHBox/ScrollContainer/SaveSlotsVBox/LineEdit

var pending_slot = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	warning_panel_backdrop.hide()
	save_slots_h_box.hide()
	delete_button.pressed.connect(_on_delete_button_pressed)

	# Connect empty save slots
	empty_save_slot_button_1.pressed.connect(func(): 
		SaveManager.save_game(1))
	empty_save_slot_button_2.pressed.connect(func(): 
		SaveManager.save_game(2))
	empty_save_slot_button_3.pressed.connect(func(): 
		SaveManager.save_game(3))
	
	# Load available save slots
	delete_save_button_1.pressed.connect(func():
		SaveManager.delete_save_slot(1))
	delete_save_button_2.pressed.connect(func():
		SaveManager.delete_save_slot(2))
	delete_save_button_3.pressed.connect(func():
		SaveManager.delete_save_slot(3))
		
	# 
	load_save_button_1.pressed.connect(func():
		SaveManager.load_game(1))
	load_save_button_2.pressed.connect(func():
		SaveManager.load_game(2))
	load_save_button_3.pressed.connect(func():
		SaveManager.load_game(3))
		
	empty_save_slot_button_1.pressed.connect(_on_empty_slots_button_pressed.bind(1))
	empty_save_slot_button_2.pressed.connect(_on_empty_slots_button_pressed.bind(2))
	empty_save_slot_button_3.pressed.connect(_on_empty_slots_button_pressed.bind(3))

	overwrite_button_1.pressed.connect(_on_overwrite_slots_button_pressed.bind(1))
	overwrite_button_2.pressed.connect(_on_overwrite_slots_button_pressed.bind(1))
	overwrite_button_3.pressed.connect(_on_overwrite_slots_button_pressed.bind(1))

	delete_save_button_1.pressed.connect(_on_delete_slots_button_pressed.bind(1))
	delete_save_button_2.pressed.connect(_on_delete_slots_button_pressed.bind(2))
	delete_save_button_3.pressed.connect(_on_delete_slots_button_pressed.bind(3))

func refresh_save_slots():
	for i in range(3):
		var has_save = SaveManager.slot_exists(i + 1)
		filled_panels[i].visible = has_save
		empty_panels[i].visible = not has_save	
		if has_save:
			var data = SaveManager.read_slot(i+ 1)
			# find_child searches inside panel, since every panel has a 'Date' label.
			
			var time_data = data.time
			
			filled_panels[i].find_child('Date', true, false).text = data.saved_at
			filled_panels[i].find_child('GameTime', true, false).text = "Day %d - %02d:%02d" % [
					time_data.day,
					time_data.hour,
					time_data.minute,
				]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape_menu"):
		toggle_menu()
	
func toggle_menu():
	visible = not visible
	if visible:
		save_slots_h_box.hide()
		escape_v_box.show()
		refresh_save_slots()
		
func _on_saves_button_pressed() -> void:
	save_slots_h_box.show()
	escape_v_box.hide()

func _on_empty_slots_button_pressed(slot:int) -> void:
	refresh_save_slots()

func _on_overwrite_slots_button_pressed(slot:int) -> void:
	_warning_message(slot, true)

func _on_overwrite_button_pressed() -> void:
	SaveManager.save_game(pending_slot)
	_close_warning()

func _on_delete_slots_button_pressed(slot:int) -> void:
	_warning_message(slot, false)

func _warning_message(slot:int, for_overwrite:bool) -> void:
	var type = 'delete'
	pending_slot = slot
	if for_overwrite:
		type = 'overwrite'
	delete_button.visible = not for_overwrite
	overwrite_button.visible = for_overwrite
	warning_panel_backdrop.show()
	warning_message.text = 'Are you sure you want to\n'+ type + ' Save Slot %d' % slot + '?'

func _on_return_button_pressed() -> void:
	show()
	save_slots_h_box.hide()
	escape_v_box.show()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_delete_button_pressed() -> void:
	SaveManager.delete_save_slot(pending_slot)
	pending_slot = 0
	print('hiding')
	warning_panel_backdrop.hide()
	refresh_save_slots()
	
func _on_cancel_button_pressed() -> void:
	_close_warning()
	
func _close_warning() -> void:
	pending_slot = 0
	warning_panel_backdrop.hide()
	refresh_save_slots()
