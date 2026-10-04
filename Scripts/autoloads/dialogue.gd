extends CanvasLayer

@onready var dialogue_backdrop: ColorRect = $DialogueBackdrop
@onready var dialogue_text: RichTextLabel = $MarginContainer/HBoxContainer/DialogueBox/MarginContainer/DialogueText
@onready var dialogue_options: VBoxContainer = $DialogueBackdrop/DialogueOptions
@onready var choice_text: RichTextLabel = $DialogueBackdrop/DialogueOptions/DialogueOption1/MarginContainer/ChoiceText

@onready var dialogue_option_1: TextureButton = $DialogueBackdrop/DialogueOptions/DialogueOption1
@onready var dialogue_option_2: TextureButton = $DialogueBackdrop/DialogueOptions/DialogueOption2
@onready var dialogue_option_3: TextureButton = $DialogueBackdrop/DialogueOptions/DialogueOption3

#Choices
@onready var choice_option_nodes: Array = [
	dialogue_option_1,
	dialogue_option_2,
	dialogue_option_3,
]

var _current_choices:Array = []

func _ready() -> void:
	print("dialogue.gd _ready called")
	hide()
	dialogue_backdrop.hide()
	dialogue_options.hide()
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.line_shown.connect(_on_line_shown)
	DialogueManager.choices_shown.connect(_on_choices_shown)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	print("dialogue.gd connected all signals")

func _on_dialogue_started() -> void:
	show()	
	

func _on_line_shown(name: String,text: String) -> void:
	print("line_shown received: ", name, " - ", text)
	_current_choices = []
	dialogue_text.text = text

func _on_choices_shown(choices: Array) -> void:
	dialogue_options.show()
	dialogue_backdrop.show()
	_current_choices = choices
	
	for i in choice_option_nodes.size():
		var option_node = choice_option_nodes[i]
		if i < choices.size():
			option_node.show()
			var label: RichTextLabel = option_node.get_node('MarginContainer/ChoiceText')
			label.text = choices[i].get('text','')
		else:
			option_node.hide()
			
func _on_dialogue_ended() -> void:
	hide()	
	dialogue_backdrop.hide()
	_current_choices = []
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialogue_selection_1"):
		_select_choice(0)
	elif Input.is_action_just_pressed("dialogue_selection_2"):
		_select_choice(1)
	elif Input.is_action_just_pressed("dialogue_selection_3"):
		_select_choice(2)	
	elif Input.is_action_just_pressed("action"):
		if 	_current_choices.is_empty():
				DialogueManager.advance()

func _select_choice(index:int) -> void:
	if index >= _current_choices.size():
		return
	_current_choices = []
	DialogueManager.select_choice(index)
