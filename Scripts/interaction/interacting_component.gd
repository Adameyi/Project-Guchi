extends Node2D

@onready var interact_label: Label = $InteractLabel

var currentInteractions := []
var canInteract := true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('interact') and canInteract:
		if currentInteractions:
			canInteract = false
			interact_label.hide()

			await currentInteractions[0].interact.call()
			canInteract = true

func _process(_delta: float) -> void:
	if currentInteractions and canInteract:
		currentInteractions.sort_custom(_sort_by_nearest)
		if currentInteractions[0].is_interactable:
			interact_label.text = currentInteractions[0].interact_name
			interact_label.show()
	else:
		interact_label.hide()

func _sort_by_nearest(area1, area2):
	var area1_distance = global_position.distance_to(area1.global_position)
	var area2_distance = global_position.distance_to(area2.global_position)
	return area1_distance < area2_distance

func _on_interact_range_area_entered(area: Area2D) -> void:
	currentInteractions.push_back(area)


func _on_interact_range_area_exited(area: Area2D) -> void:
	currentInteractions.erase(area)
