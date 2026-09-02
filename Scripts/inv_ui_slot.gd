extends Control

@onready var item_display: Sprite2D = $CenterContainer/Panel/item_display
@onready var count: Label = $CenterContainer/Panel/count


func update(slot: Inventory_Slot):
	if !slot.item:
		item_display.visible = false
		count.visible = false
	else:
		item_display.visible = true
		item_display.texture = slot.item.texture
		if slot.amount > 1:
			count.visible = true
		count.text = str(slot.amount)
