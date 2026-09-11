extends Node

signal progress_changed(progress)
signal load_finished

#loading_Screen.tscn
var loading_screen: PackedScene = preload("uid://d3f8udalobbsv")
var loaded_resource: PackedScene
var scene_path: String
var progress: Array = []

#Resource loader will try to load a scene using multiple threads in the background. 
var use_sub_threads: bool = true

func _ready() -> void:
	set_process(false)
	
func load_scene(_scene_path: String) -> void:
	scene_path = _scene_path
	
	var new_load_scene = loading_screen.instantiate()
	add_child(new_load_scene)
	
	#Loading screen will play fade-in animation. Wait to switch the main scene until loading screen fully covers the scene.
	progress_changed.connect(new_load_scene._on_progress_changed)
	load_finished.connect(new_load_scene._on_load_finished)
	
	await new_load_scene.loading_screen_ready
	start_load()
	
func start_load() -> void:
	#Start the resource loader to load a scene file
	var state = ResourceLoader.load_threaded_request(scene_path, '', use_sub_threads)
	if state == OK:
		set_process(true)

func _process(_delta: float) -> void:
	#Get status of load and check status.
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	progress_changed.emit(progress[0])
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			get_tree().change_scene_to_packed(loaded_resource)
			load_finished.emit()
			
