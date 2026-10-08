class_name StoreItem
extends VBoxContainer

signal buy_pressed(item_id: StringName)
@onready var store_item_stock: Label = $StoreItemBackground/MarginContainer/StoreItemStock
@onready var store_item_image: TextureRect = $StoreItemBackground/MarginContainer2/StoreItemImage
@onready var store_item_label: Label = $HBoxContainer/StoreItemLabel
@onready var store_item_price: Label = $HBoxContainer/StoreItemPrice


var _data: ShopItemData

func set_data(data: ShopItemData) -> void:
		_data = data
		store_item_image.texture = data.icon
		store_item_label.text = data.display_name
		store_item_price.text = str(data.price)
		_update_stock_display()
		if not Economy.stock_update.is_connected(_on_stock_update):
			Economy.stock_update.connect(_on_stock_update)
		
func _update_stock_display() -> void:
	if _data.stock < 0: 
		store_item_stock.text = '∞'
	else:
		store_item_stock.text = str(_data.stock)

func _on_buy_button_pressed() -> void:
	buy_pressed.emit(_data.id)

func _on_stock_update(item_id: StringName, new_stock: int) -> void:
	if item_id == _data.id:
		print('New Stock: ', new_stock)
		_update_stock_display()
