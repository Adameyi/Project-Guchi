extends Node2D

@export var crop_data: CropData
var stage := 0
var is_planted := false
var is_watered := false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var water: ColorRect = $Water
@onready var growth_timer: Timer = $GrowthTimer

func _ready() -> void:
	water.hide()
	growth_timer.one_shot = true #One tick per growth stage
	if crop_data:
		is_planted = true
		_apply_crop_data()
		
func _apply_crop_data() -> void:
	if crop_data.sprite_frames:
		animated_sprite_2d.sprite_frames. crop_data.sprite_frmaes
	animated_sprite_2d.play('stage_%d' % stage)

func _start_growing() -> void:
	if is_planted and is_watered and stage < crop_data.max_stage and growth_timer.is_stopped():
		growth_timer.start(crop_data.grow_time) 

func plant(data: CropData) -> void:
	crop_data = data
	crop_data.planted = true
	stage = 0
	_apply_crop_data()
	_start_growing()
		
func grow() -> void:
	if not is_planted or stage >= crop_data.max_stage:
		return 
	stage += 1
	animated_sprite_2d.play('stage_%d' % stage)
	is_watered = false
	water.hide()

func watered():
	is_watered = true
	water.show()
	_start_growing()

func _on_growth_timer_timeout() -> void:
	grow()

func _is_harvestable() -> bool:
	return is_planted and stage >= crop_data.max_stage
	
func reset_to_soil() -> void:
	growth_timer.stop()
	stage = 0
	is_watered = false
	is_planted = false
	water.hide()
	animated_sprite_2d.play('stage_0')
