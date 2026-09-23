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
		
func _update_stock_display() -> void:
	if _data.stock < 0: 
		store_item_stock.text = '∞'
	else:
		store_item_stock.text = str(_data.stock)

func _on_buy_button_pressed() -> void:
	buy_pressed.emit(_data.id)
