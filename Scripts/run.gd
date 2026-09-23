extends CharacterBody2D

@export var speed:float = 100.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var inventory: Inventory = preload('res://inventory/player_inventory.tres')

func _ready() -> void:
	#Starting Items
	for i in range(5):
		inventory.insert(preload("res://inventory/items/sunflower_seed.tres"))
	
func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector('run_left', 'run_right', 'run_up', 'run_down')
	velocity = direction * speed
	
	move_and_slide()
	update_animation(direction)
	
func update_animation(direction:Vector2) -> void:
	if direction.length() > 0:
		animated_sprite_2d.play('run_leftright')
		if direction.x != 0:
			animated_sprite_2d.flip_h = direction.x < 0
	else:
		animated_sprite_2d.play('idle')
