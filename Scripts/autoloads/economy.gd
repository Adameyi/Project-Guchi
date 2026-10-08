extends Node

signal balance_changed(new_balance: int)
signal purchase_failed(item_id: StringName, error: String)
signal purchase_success(item_id)
signal stock_update(item_id: StringName, new_stock: int)

@export var item_catalog: Array[ShopItemData] = [] 
@onready var inventory: Inventory = preload("res://Inventory/player_inventory.tres")

var _bal: int = 100

func _ready() -> void:
	item_catalog = _load_all_shop_items('res://Shop/items/')
	print('catalog: ', item_catalog.map(func(d): return d.display_name))

func get_bal() -> int:
	return _bal
	
func add_gold(amount: int) -> void:
	_bal += amount
	balance_changed.emit(_bal)

func can_afford(price: int) -> bool:
	return _bal >= price	
	
func buy_item(item_id: StringName) -> void:
	var data:= _find_item_data(item_id)
	if data == null:
		print('Not Found')
		purchase_failed.emit(item_id, 'not found')
		return
	if data.stock == 0:
		print('Out of Stock')
		purchase_failed.emit(item_id, 'out of stock!')
		return
	if !can_afford(data.price):
		print('insufficent funds')
		purchase_failed.emit(item_id, 'insufficient funds!')
		return

	_bal -= data.price
	data.stock -= 1	
	balance_changed.emit(_bal)
	purchase_success.emit(item_id)
	print('Success Item: ', data.item, '| texture: ',  data.item.texture if data.item else '[N/A]')
	print('Economy Inv: ', inventory.resource_path)
	inventory.insert(data.item)
	print('first slots: ', inventory.slots.map(func(s): return str(s.item)	+ ' x' + str(s.amount)).slice(0, 5))
	print('Remaining Stock: ', data.stock)
	inventory.update.emit()
	stock_update.emit(item_id, data.stock)
	
		
func _find_item_data(item_id: StringName) -> ShopItemData:
	print(item_catalog)
	for item in item_catalog:
		if item.id == item_id:
			return item
	return null

func _load_all_shop_items(dir_path: String) -> Array[ShopItemData]:
	var result: Array[ShopItemData] = []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return result
	dir.list_dir_begin()
	var filename := dir.get_next()
	while filename != '':
		if filename.ends_with('.tres'):
			var res := load(dir_path.path_join(filename)) as ShopItemData
			if res:
				result.append(res)
		filename = dir.get_next()
	dir.list_dir_end()
	return result
	
