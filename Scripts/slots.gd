extends TextureButton

@onready var count: Label = $CenterContainer/Panel/count
@onready var item_display: Sprite2D = $CenterContainer/Panel/item_display

@export var texture_selected: Texture2D
var _texture_normal_cache: Texture2D
var index: int = 0

func _ready() -> void:
	_texture_normal_cache = texture_normal

func set_selected(value:bool) -> void:
	texture_normal = texture_selected if value else _texture_normal_cache

func update(slot: Inventory_Slot) -> void:
	if !slot.item:
		item_display.visible = false
		count.visible = false
	else:
		item_display.visible = true
		item_display.texture = slot.item.texture
		count.visible = slot.amount > 1
		count.text = str(slot.amount)
