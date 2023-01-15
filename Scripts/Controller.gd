extends Node3D
class_name PlayerController

var characters : Array[Node]
var camera : PlayerCamera

var character_index : float = 0
var move_direction : Vector2 = Vector2.ZERO
var look_direction : Vector2 = Vector2.ZERO

var character: PlayerCharacter:
	get:
		return characters[character_index] as PlayerCharacter


func _ready():
	characters = get_tree().get_nodes_in_group("Character")
	camera = get_tree().get_first_node_in_group("Camera")
	
	setup_camera()


func _process(delta):
	input_poll()
	update_camera()
	update_player()
	look_direction = Vector2.ZERO


func _input(event):
	if event.is_action_pressed("character_switch"):
		switch_character()
	
	if event is InputEventMouseMotion:
			look_direction = event.relative
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func input_poll():
	move_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")


func switch_character():
	character_index = wrapi(character_index + 1, 0, characters.size())
	setup_camera()


func setup_player():
	pass


func update_player():
	character.move_direction = move_direction
	character.rotate_direction = look_direction


func setup_camera():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.character = character
	camera.global_rotation = character.global_rotation


func update_camera():
	camera.mouse_delta = look_direction
