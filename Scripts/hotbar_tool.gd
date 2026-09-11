extends TextureButton

var tools = ['None','Hoe','Watering_Can','Remove']
var mode = 0

@onready var texture_button: TextureButton = $"."
@export var hoe_texture: Texture2D = preload("res://Assets/PlayerUI/tool-inventory-hoe.png")
@export var watering_can: Texture2D	= preload("res://Assets/PlayerUI/tool-inventory-wateringcan.png")
@export var remove: Texture2D = preload("res://Assets/PlayerUI/tool-inventory-remove.png")
@export var none: Texture2D = preload("res://Assets/PlayerUI/tool-inventory-background.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('change_tool'):
		ChangeMode(1)

func ChangeMode(value):
	mode = (mode + value)  % tools.size()
	print('Item: ', tools[mode])
	print('Mode: ', mode)
	var selected_tool = tools[mode]
	if selected_tool == 'Hoe':
		texture_button.texture_normal = hoe_texture
	elif selected_tool == 'Watering_Can':
		texture_button.texture_normal = watering_can
	elif selected_tool == 'Remove':
		texture_button.texture_normal = remove
	else:
		texture_button.texture_normal = none

func getCurrentTool() -> String:
	return tools[mode]
