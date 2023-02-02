extends CharacterBody3D
class_name PlayerCharacter


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum CONTROL_STATE {NONE, INPUT, NAVIGATION}
enum CHARACTER_SKILL {NONE, GROW, DIVIDE}

# On Ready Vars-------------------------------------------------------------------------------------
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var default_camera_offset : Vector3 = camera_offset

# Export Vars---------------------------------------------------------------------------------------
@export var character_skill : CHARACTER_SKILL
@export var base_character : PackedScene
@export var decoy_character : PackedScene
@export var preview_character : PackedScene

# Member Vars---------------------------------------------------------------------------------------
var control_state : CONTROL_STATE
var is_skill_on : bool
var split_character : Node3D

var move_direction : Vector2
var move_speed : float = 5.0
var rotate_speed : float = 1
var rotate_direction : Vector2
var additional_forces : Vector3

var camera_offset : Vector3 = Vector3(0, 1.8, 0)

var nav_destination : Vector3

var can_move : bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Bult-In Functions---------------------------------------------------------------------------------
func _process(delta):
	rotate_character(delta)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	match control_state:
		CONTROL_STATE.NONE:
			velocity = Vector3.ZERO + additional_forces
			move_and_slide()
		CONTROL_STATE.INPUT:
			move_input(move_direction, delta)
		CONTROL_STATE.NAVIGATION:
			move_nav()


# Connected Signals---------------------------------------------------------------------------------
func _on_preview_character_spawned_character(spawned_character : Node3D):
	split_character = spawned_character
	split_character.control_state = PlayerCharacter.CONTROL_STATE.NAVIGATION


# INPUT Movement Functions--------------------------------------------------------------------------
func move_input(direction : Vector2, delta : float):
	var new_direction = (transform.basis * Vector3(direction.x, 0, direction.y)).normalized()
	if new_direction:
		velocity.x = new_direction.x * SPEED
		velocity.z = new_direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	velocity += additional_forces

	move_and_slide()


func move_nav():
	# if nav_destination == null: return

	var current_position : Vector3 = global_transform.origin
	var next_position : Vector3 = nav_agent.get_next_path_position()
	var direction : Vector3 = next_position - current_position
	var distance : float = current_position.distance_to(next_position)

	if distance >= 0.1:
		direction = direction.normalized()
		velocity = direction * move_speed

		# rotate_direction = Vector2(direction.x, direction.z).normalized()
		look_at(next_position)

		move_and_slide()


func rotate_character(delta : float):
	rotate_y(rotate_direction.x * -0.25 * delta)
	# print(rotation)


func set_new_nav_destination(new_destination : Vector3):
	nav_destination = new_destination
	nav_agent.target_position = new_destination


# Divide Character Funcs----------------------------------------------------------------------------
func divide_character():
	if !is_skill_on:
		can_move = false

		# Store initial transform
		var starting_trans : Transform3D = transform
		# var starting_pos : Vector3 = position

		# Spawn decoy body to cover up transitions
		var decoy_body = decoy_character.instantiate()
		decoy_body.transform = starting_trans
		get_parent().add_child(decoy_body)

		# Move original character up
		$Temp_Body.mesh.height = 1.0
		$Temp_Body.position.y = 0.5
		$CollisionShape3D.shape.height = 1.0
		$CollisionShape3D.position.y = 0.5
		
		var tween_position = get_tree().create_tween()
		tween_position.tween_property(self, "position", position + Vector3.UP, 0.25)
		var tween_camera_offset = get_tree().create_tween()
		var new_camera_offset = Vector3(0, 0.8, 0)
		tween_camera_offset.tween_property(self, "camera_offset", new_camera_offset, 0.25)
		await tween_position.finished

		# Spawn dummy character
		var dummy_character = preview_character.instantiate()
		# dummy_character.position = starting_pos
		dummy_character.transform = starting_trans
		get_parent().add_child(dummy_character)
		dummy_character.spawned_character.connect(_on_preview_character_spawned_character)

		var tween_body_scale = get_tree().create_tween()
		tween_body_scale.tween_property(decoy_body, "scale", Vector3.ZERO, 0.25)
		await tween_body_scale.finished
		decoy_body.queue_free()
		
		can_move = true
		is_skill_on = true
	elif split_character != null:
		var change_height : Tween = get_tree().create_tween()
		var change_offset : Tween = get_tree().create_tween()
		var change_col_height : Tween = get_tree().create_tween()
		var change_col_offset : Tween = get_tree().create_tween()
		var change_dummy_scale : Tween = get_tree().create_tween()
		var tween_camera_offset = get_tree().create_tween()
		var new_camera_offset = default_camera_offset
		tween_camera_offset.tween_property(self, "camera_offset", new_camera_offset, 0.25)
		change_height.tween_property($Temp_Body, "mesh:height", 2.0, 0.25)
		change_offset.tween_property($Temp_Body, "position:y", 1.0, 0.25)
		change_col_height.tween_property($CollisionShape3D, "shape:height", 2, 0.25)
		change_col_offset.tween_property($CollisionShape3D, "position:y", 1.0, 0.25)
		change_dummy_scale.tween_property(split_character, "scale", Vector3.ZERO, 0.25)
		await change_dummy_scale.finished
		split_character.queue_free()
		is_skill_on = false

func command_twin(destination : Vector3):
	if is_skill_on and split_character != null:
		(split_character as PlayerCharacter).set_new_nav_destination(destination)
	else:
		pass


# Grow Character Funcs------------------------------------------------------------------------------
func grow_character(is_grow : bool):
	var change_mesh_scale : Tween = get_tree().create_tween()
	var change_mesh_offset : Tween = get_tree().create_tween()
	var change_col_scale : Tween = get_tree().create_tween()
	var change_col_offset : Tween = get_tree().create_tween()
	var change_camera_offset : Tween = get_tree().create_tween()

	var new_size : Vector3 = Vector3(0.5, 3, 0.5) if is_grow else Vector3(2, 1, 2)
	var original_size : Vector3 = Vector3(0.75, 2, 0.75)

	var new_offset : float = new_size.y / 2
	var original_offset : float = original_size.y / 2

	var new_camera_offset : Vector3 = Vector3(0, 2.8, 0) if is_grow else Vector3(0, 0.8, 0)

	if !is_skill_on:
		change_mesh_scale.tween_property($Temp_Body, "mesh:size", new_size, 0.25)
		change_mesh_offset.tween_property($Temp_Body, "position:y", new_offset, 0.25)

		change_col_scale.tween_property($CollisionShape3D, "shape:size", new_size, 0.25)
		change_col_offset.tween_property($CollisionShape3D, "position:y", new_offset, 0.25)

		change_camera_offset.tween_property(self, "camera_offset", new_camera_offset, 0.25)
	else:
		change_mesh_scale.tween_property($Temp_Body, "mesh:size", original_size, 0.25)
		change_mesh_offset.tween_property($Temp_Body, "position:y", original_offset, 0.25)

		change_col_scale.tween_property($CollisionShape3D, "shape:size", original_size, 0.25)
		change_col_offset.tween_property($CollisionShape3D, "position:y", original_offset, 0.25)

		change_camera_offset.tween_property(self, "camera_offset", default_camera_offset, 0.25)
	
	is_skill_on = !is_skill_on
