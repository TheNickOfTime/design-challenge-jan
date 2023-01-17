extends Node3D
class_name PlayerController

var characters : Array[Node]
var camera : PlayerCamera
var camera_directions : Array[Transform3D]

var character_index : int = 0
var move_direction : Vector2 = Vector2.ZERO
var look_direction : Vector2 = Vector2.ZERO

var current_character: PlayerCharacter:
	get:
		return characters[character_index] as PlayerCharacter

var other_character: PlayerCharacter:
	get:
		var index = wrapi(character_index + 1, 0, characters.size())
		return characters[index] as PlayerCharacter


#Built In Functions---------------------------------------------------------------------------------
func _ready():
	characters = get_tree().get_nodes_in_group("Character")
	camera = get_tree().get_first_node_in_group("Camera")
	camera_directions.resize(2)
	for i in camera_directions.size():
		camera_directions[i] = camera.transform
	
	setup_player()
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
	
	if event.is_action_pressed("character_command"):
		update_nav_destination()


func input_poll():
	move_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")


# Character Functions-------------------------------------------------------------------------------
func switch_character():
	# save previous values
	camera_directions[character_index] = camera.transform

	# set new values
	character_index = wrapi(character_index + 1, 0, characters.size())
	setup_player()
	setup_camera()


func setup_player():
	for character in characters:
		character = character as PlayerCharacter
		
		if character == current_character:
			character.control_state = PlayerCharacter.CONTROL_STATE.Input
		else:
			character.nav_destination = character.position
			character.control_state = PlayerCharacter.CONTROL_STATE.Navigation


func update_player():
	current_character.move_direction = move_direction
	current_character.rotate_direction = look_direction


func update_nav_destination():
	var new_destination = camera.get_position_from_raycast()
	print(new_destination)
	if new_destination != null:
		other_character.set_new_nav_destination(new_destination)


# Camera Functions----------------------------------------------------------------------------------
func setup_camera():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.character = current_character
	# camera.global_rotation = current_character.global_rotation
	if camera_directions[character_index] != null:

		camera.transform = camera_directions[character_index]


func update_camera():
	camera.mouse_delta = look_direction