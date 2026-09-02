extends TextureButton
@onready var tool_ui_slot: TextureButton = $"../Tool_UI_Slot"


func _on_pressed() -> void:
	tool_ui_slot.ChangeMode(+1)
