extends Node3D
class_name PlayerController


signal character_switch(character : PlayerCharacter)
signal character_region_changed(is_same : bool)

var hud : HUD

var characters : Array[Node]
var camera : PlayerCamera
var camera_directions : Array[Transform3D]

var character_index : int = 0
var move_direction : Vector2 = Vector2.ZERO
var look_direction : Vector2 = Vector2.ZERO

var can_move_character : bool = false
var can_move_camera : bool = false
var can_switch_character : bool = true

var current_character: PlayerCharacter:
	get:
		return characters[character_index] as PlayerCharacter

var other_character: PlayerCharacter:
	get:
		var index = wrapi(character_index + 1, 0, characters.size())
		return characters[index] as PlayerCharacter


#Built In Functions---------------------------------------------------------------------------------
func _enter_tree():
	characters.resize(2)


func _ready():
	# characters = get_tree().get_nodes_in_group("Character")
	camera = get_tree().get_first_node_in_group("Camera")
	camera_directions.resize(2)
	for i in camera_directions.size():
		camera_directions[i] = camera.transform
	
	await get_tree().process_frame

	setup_player()
	setup_camera()
	
	await get_tree().process_frame

	character_switch.connect(hud._on_controller_character_switch)
	other_character.character_split.connect(hud._on_character_character_split)
	character_region_changed.connect(hud._on_character_region_changed)

	character_switch.emit(current_character)
	check_character_regions()

	can_move_character = true
	can_move_camera = true


func _process(delta):
	
	input_poll()
	update_camera()
	update_player()

	look_direction = Vector2.ZERO


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if can_move_character:
		if event.is_action_pressed("character_switch"):
			switch_character()
		
		if event.is_action_pressed("character_interact"):
			current_character.interact()
		
		if event.is_action_pressed("skill_primary"):
			character_skill_primary()
		
		if event.is_action_pressed("skill_secondary"):
			character_skill_secondary()
	
	if can_move_camera:
		if event is InputEventMouseMotion:
			look_direction = event.relative
	
	if event is InputEventMouseButton:
		print(event.button_index)
		if (event as InputEventMouseButton).button_index == 1:
			if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func input_poll():
	if can_move_character:
		move_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")


# Character Functions-------------------------------------------------------------------------------
func switch_character():
	if !can_switch_character: return

	current_character.rotate_direction = Vector2.ZERO

	# save previous values
	camera_directions[character_index] = camera.transform

	# set new values
	character_index = wrapi(character_index + 1, 0, characters.size())
	setup_player()
	setup_camera()

	character_switch.emit(current_character)
	if current_character is PlayerCharacter_Divide:
		current_character.character_split.emit(current_character)


func setup_player():
	for character in characters:
		character = character as PlayerCharacter
		
		if character == current_character:
			character.control_state = PlayerCharacter.CONTROL_STATE.INPUT
		else:
			character.nav_destination = character.position
			character.control_state = PlayerCharacter.CONTROL_STATE.NONE


func update_player():
	current_character.move_direction = move_direction
	current_character.rotate_direction = look_direction


func update_nav_destination():
	var new_destination = camera.get_position_from_raycast()
	# print(new_destination)
	if new_destination != null:
		other_character.set_new_nav_destination(new_destination)


func character_skill_primary():
	current_character.primary_skill()

func character_skill_secondary():
	if current_character is PlayerCharacter_Divide:
		current_character.twin_destination = camera.get_position_from_raycast()
	current_character.secondary_skill()


func check_character_regions():
	var is_same_region : bool = current_character.character_region == other_character.character_region
	character_region_changed.emit(is_same_region)
	can_switch_character = is_same_region
	print(is_same_region)


# Camera Functions----------------------------------------------------------------------------------
func setup_camera():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.character = current_character
	camera.global_rotation.y = current_character.global_rotation.y
	camera.global_rotation.z = current_character.global_rotation.z


func update_camera():
	camera.mouse_delta = look_direction
