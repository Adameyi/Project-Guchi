extends Control

@onready var inventory: Inventory = preload('res://inventory/player_inventory.tres')
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready() -> void:
	inventory.update.connect(UpdateSlots)
	UpdateSlots()
	OpenCloseInventory(is_open)

func UpdateSlots():
	for i in range(min(inventory.slots.size(), slots.size())):
			slots[i].update(inventory.slots[i])

func _process(_delta):
	if Input.is_action_just_pressed('open_inventory'):
		OpenCloseInventory(is_open)

func OpenCloseInventory(state):
	visible = state
	is_open = !state
	print('Inventory Open: ', !is_open)
	
