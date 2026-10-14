extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var water: ColorRect = $Water
@onready var growth_timer: Timer = $GrowthTimer

@export var soil_frame: SpriteFrames

var stage := 0
var is_planted := false
var is_watered := false
var crop_data: CropData = null

func _ready() -> void:
	_show_soil()

func _show_soil() -> void:
	animated_sprite_2d.sprite_frames = soil_frame
	animated_sprite_2d.animation = &"default"
	animated_sprite_2d.stop()
	animated_sprite_2d.frame = 0

func _apply_crop_data() -> void:
	animated_sprite_2d.sprite_frames = crop_data.sprite_frames
	animated_sprite_2d.animation = &"default"
	animated_sprite_2d.stop()
	_set_stage(0)
	
func _set_stage(new_stage:int) -> void:
	stage = clampi(new_stage, 0, crop_data.max_stage)
	animated_sprite_2d.frame = stage

func _start_growing() -> void:
	if is_planted and is_watered and stage < crop_data.max_stage and growth_timer.is_stopped():
		growth_timer.start(crop_data.grow_time) 

func plant(data: CropData) -> void:
	crop_data = data
	is_planted = true
	stage = 0
	water.hide()
	_apply_crop_data()
		
func grow() -> void:
	if not is_planted or stage >= crop_data.max_stage:
		return 
	stage += 1
	animated_sprite_2d.play('stage_%d' % stage)
	is_watered = false
	water.hide()

func watered():
	if not is_planted:
		return
	is_watered = true
	water.show()
	_start_growing()

func _on_growth_timer_timeout() -> void:
	grow()

func _is_harvestable() -> bool:
	return is_planted and crop_data !=null and stage >= crop_data.max_stage
	
func reset_to_soil() -> void:
	crop_data = null
	growth_timer.stop()
	stage = 0
	is_watered = false
	is_planted = false
	water.hide()
	_show_soil()
