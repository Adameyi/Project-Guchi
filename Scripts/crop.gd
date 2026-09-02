extends Node2D

@export var crop_data: CropData
var stage := 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var water: ColorRect = $Water

func _ready() -> void:
	water.hide()
	if crop_data:
		animated_sprite_2d.sprite_frames = crop_data.sprite_frames
		animated_sprite_2d.play('stage_0')
		print('Iniital Stage: ', stage)
		
func grow() -> void:
	if not crop_data:
		print('Crop Data: ', crop_data)
		return
	stage +=1
	print('Growing..')
	if stage <= crop_data.max_stage:
		animated_sprite_2d.play('stage_%d' % stage)

func watered():
	water.show()
