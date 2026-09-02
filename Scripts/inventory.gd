extends Resource

class_name Inventory

signal update

@export var slots:Array[Inventory_Slot]


func insert(item: Inventory_Item, emit_signal:bool=true):
	#Check if the first item slot is available
	var itemslots = slots.filter(func(slot) : return slot.item == item)
	#Increment item count by 1
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		#Update empty slot to include item.
		var emptyslots = slots.filter(func(slot) : return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	if emit_signal:
		update.emit()
