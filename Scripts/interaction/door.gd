extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#const SHOP = preload("uid://cnc3k1e7dook5")
@export var initial_scene: StringName = &''

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	SceneLoader.load_scene(initial_scene)
