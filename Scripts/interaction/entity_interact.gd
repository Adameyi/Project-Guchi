extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#const MAIN = preload("uid://bhnl8hn71jrhp")
#const SHOP = preload("uid://cnc3k1e7dook5")
enum InteractType {LOAD_SCENE, NPC_DIALOGUE}
@export var interact_type: InteractType
@export var initial_scene: StringName = &'' #scene to load
@export var spawn_point: StringName = &"" #marker2D name
@export var dialogue_path: String = 'res://Dialogue/dialogue.json'


func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
		match interact_type:
			InteractType.LOAD_SCENE:
				SceneLoader.next_spawn = spawn_point
				SceneLoader.load_scene(initial_scene)
			InteractType.NPC_DIALOGUE:
				print("Opening Dialogue: ", interact_type)
				DialogueManager.start_dialogue(dialogue_path)
