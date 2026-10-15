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
		
func remove(item: Inventory_Item, amount: int=1, emit_signal:bool=true) -> bool:
		#Count how many the player has across all slots.
		var total := 0
		for slot in slots:
			if slot.item == item:
				total += slot.amount
			if total < amount:
				return false
				
		#Take from slots until enough is removed
		var remaining := amount
		for slot in slots:
			if remaining <= 0:
				break
			if slot.item != item:
				continue
			var taken:= mini(slot.amount, remaining)
			slot.amount -= taken
			remaining -= taken
			if slot.amount <= 0:
				slot.item = null
				slot.amount = 0
		if emit_signal:
			update.emit()
		return true
