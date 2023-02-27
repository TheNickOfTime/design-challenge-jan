extends Node


signal level_loaded(level_resource : PackedScene)
signal finished_loading

var previous_level : Node3D
var current_level : Node3D
var loading_level : String
var loader


func _enter_tree():
	pass


func _ready():
	current_level = get_tree().current_scene
	await get_tree().process_frame
	reparent_loading_room()


func _process(delta):
	if loader != null:
		if ResourceLoader.load_threaded_get_status(loading_level) == ResourceLoader.THREAD_LOAD_LOADED:
			finished_loading.emit()
			pass


func load_level(level : String):
	loading_level = level
	loader = ResourceLoader.load_threaded_request(level)

	if current_level != null:
		# current_level.process_mode = Node.PROCESS_MODE_DISABLED
		# await get_tree().create_timer(3.0).timeout
		current_level.queue_free()

	await finished_loading

	var new_level : PackedScene = ResourceLoader.load_threaded_get(loading_level)
	current_level = new_level.instantiate()
	get_tree().root.add_child(current_level)
	level_loaded.emit(new_level)
	loader = null

	reparent_loading_room()


func reparent_loading_room():
	var loading_room : Node3D = current_level.find_child("Loading_Room", true, false)
	if loading_room == null:
		print_debug("No loading room present for " + current_level.name)
		return

	loading_room.reparent(get_tree().root)
