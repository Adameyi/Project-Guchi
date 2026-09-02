extends Node2D

@export var item: Inventory_Item
@onready var player: Node2D = $"../Player"
@onready var growth_timer: Timer = $growth_timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D


var state = 'no_apples' #Tree can have: apples | no apples
var player_in_area = false

var apple = preload('res://Scenes/apple_collectable.tscn')

func _ready() -> void:
	if state == 'no_apples':
		growth_timer.start()

func _process(delta):
	if state == 'no_apples':
		animated_sprite_2d.play('no_apples')
	if state == 'apples':
		if player_in_area == true:
			if Input.is_action_just_pressed('collect_item'):
				print('Item Collected')
				state = 'no_apples'
				drop_apple()
		animated_sprite_2d.play('apples')

func drop_apple():
	await get_tree().create_timer(0.0).timeout
	var apple_instance = apple.instantiate()
	apple_instance.rotation = rotation
	apple_instance.global_position = marker_2d.global_position
	get_parent().add_child(apple_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	growth_timer.start()

func _on_pickable_area_body_shape_entered(
	body_rid: RID,
	body: Node2D,
	body_shape_index: int,
	local_shape_index: int
) -> void:
	if body.is_in_group("player"):
		print("Player detected")
		player_in_area = true
		player = body.get_parent()
	else:
		print("Player not detected: ", body)

func _on_pickable_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method('Player'):
		player_in_area = false

func _on_growth_timer_timeout() -> void:
	if state == 'no_apples':
		state = 'apples'
