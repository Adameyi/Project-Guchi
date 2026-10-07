extends Control

@export var item_datas: Array[ShopItemData] = []
@onready var store_items_list: GridContainer = $HBoxContainer/MarginContainer/VBoxContainer/StorePanel/ScrollContainer/StoreItemsList
@onready var buy_button: TextureButton = $HBoxContainer/MarginContainer/VBoxContainer/StorePanel/ScrollContainer/StoreItemsList/StoreItem/BuyButton
@onready var player_money: Label = $HBoxContainer/PanelContainer/MarginContainer/PlayerMoneyPanel/MarginContainer/PlayerMoney
@onready var exit_button: TextureButton = $HBoxContainer/PanelContainer/MarginContainer/ExitButton
@onready var shop: Control = $"."

var _item_nodes: Array[StoreItem] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop.hide()
	
	DialogueManager.open_shop.connect(_open_shop)
	Economy.balance_changed.connect(_on_balance_changed)
	_on_balance_changed(Economy.get_bal())
	_item_nodes = []
	if store_items_list == null:
		print("store_items_list is null!")
		return

	for child in store_items_list.get_children():
		print('Child Name: ', child.name, ' | is StoreItem: ', child is StoreItem)
		if child is StoreItem:
			_item_nodes.append(child)
	
	for i in _item_nodes.size():
		if i < item_datas.size():
			var node := _item_nodes[i]
			node.set_data(item_datas[i])
			node.buy_pressed.connect(_on_buy_button_pressed)
			node.show()
		
		else:
			_item_nodes[i].hide() #Fewer data entries than slots.

func _open_shop() -> void:
	print('opening shop')
	shop.show()

func _exit_shop() -> void:
	shop.hide()

#Check money before purchase
func _on_buy_button_pressed(item_id: StringName) -> void:
	print('Buying item: ', item_id)
	Economy.buy_item(item_id)

func _on_balance_changed(new_balance: int):
	player_money.text = str(new_balance)


func _on_exit_button_pressed() -> void:
	_exit_shop()
