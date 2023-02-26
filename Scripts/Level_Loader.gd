extends Node


signal level_loaded(level_resource : PackedScene)
signal finished_loading

var previous_level : Node3D
var current_level : Node3D
var loading_level : String
var loader


func _process(delta):
	if loader != null:
		if ResourceLoader.load_threaded_get_status(loading_level) == ResourceLoader.THREAD_LOAD_LOADED:
			finished_loading.emit()
			pass


func load_level(level : String):
	loading_level = level
	loader = ResourceLoader.load_threaded_request(level)

	if current_level != null:
		current_level.queue_free()

	await finished_loading

	var new_level : PackedScene = ResourceLoader.load_threaded_get(loading_level)
	current_level = new_level.instantiate()
	level_loaded.emit(new_level)
	loader = null
