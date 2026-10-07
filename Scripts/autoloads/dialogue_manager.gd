extends Node

signal dialogue_started()
signal line_shown(name: String, text: String)
signal choices_shown(choices: Array)
signal dialogue_ended()
signal open_shop

var _lines: Array = []
var _choices: Array = []
var _line_index: int = 0
var _active: bool = false


func _dialogue_Active() -> bool:
	return _active
	
func start_dialogue(json_path: String) -> void:
	var data:= _load_json_dialogue(json_path)
	if data.is_empty():
		return
		
	_lines = data.get('lines', [])
	_choices = data.get('choices', [])
	_line_index = 0
	_active = true
	
	dialogue_started.emit()
	_show_current_line()
	
func _load_json_dialogue(path: String) -> Dictionary:
	print('Selected Path: ' + path)
	if not FileAccess.file_exists(path):
		push_warning('Invalid Dialogue Path: ' + path)
		return {}
	var file:= FileAccess.open(path, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	if !parsed:
		push_warning('Failed to parse JSON Dialogue: ' + path)
		return {}
	return parsed
	
func _show_current_line() -> void:
	var line: Dictionary = _lines[_line_index]
	line_shown.emit(line.get("name",""), line.get("text", ""))
	
func _show_choices_or_end() -> void:
	if _choices.is_empty():
		_end_dialogue()
	else:
		choices_shown.emit(_choices)

func advance() -> void:
	if not _active:
		return
	_line_index += 1
	if _line_index < _lines.size():
		_show_current_line()
	else:
		_show_choices_or_end()

func select_choice(index: int) -> void:
	# No Available Choices.
	if index < 0 || index >= _choices.size():
		return
	var action: String = _choices[index].get("action","exit_dialogue")
	_handle_action(action)

func _handle_action(action: String) -> void:
	print("1. action received: '", action, "'")
	if action == "open_shop":
		print("1. emitting open_shop")
		open_shop.emit()
		_end_dialogue()
	elif action == "exit_dialogue":
		print("2. exiting dialogue")
		_end_dialogue()
	#Next Line
	elif action.begins_with("goto:"):
		var next_id := action.trim_prefix('goto:')
		start_dialogue('res://dialogue/%s.json' % next_id)
	else:
		push_warning('Unknown dialogue action: ' + action)

func _end_dialogue() -> void:
	_active = false
	dialogue_ended.emit()
