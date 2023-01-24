extends CharacterBody3D
class_name PlayerCharacter


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum CONTROL_STATE {Input, Navigation}
enum CHARACTER_SKILL {NONE, GROW, DIVIDE}

# On Ready Vars-------------------------------------------------------------------------------------
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

# Export Vars---------------------------------------------------------------------------------------
@export var character_skill : CHARACTER_SKILL
@export var base_character : PackedScene
@export var preview_character : PackedScene

# Member Vars---------------------------------------------------------------------------------------
var control_state : CONTROL_STATE
var is_skill_on : bool
var split_character : Node3D

var move_direction : Vector2
var move_speed : float = 5.0
var rotate_speed : float = 1
var rotate_direction : Vector2

var nav_destination : Vector3

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
		CONTROL_STATE.Input:
			move_input(move_direction)
		CONTROL_STATE.Navigation:
			move_nav()


# Connected Signals---------------------------------------------------------------------------------
func _on_preview_character_spawned_character(spawned_character : Node3D):
	split_character = spawned_character


# Input Movement Functions--------------------------------------------------------------------------
func move_input(direction : Vector2):
	var new_direction = (transform.basis * Vector3(direction.x, 0, direction.y)).normalized()
	if new_direction:
		velocity.x = new_direction.x * SPEED
		velocity.z = new_direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func move_nav():
	var current_position : Vector3 = global_transform.origin
	var next_position : Vector3 = nav_agent.get_next_location()
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
	nav_agent.set_target_location(new_destination)


func divide_character():
	var change_scale : Tween = get_tree().create_tween()
	
	if !is_skill_on:
		change_scale.tween_property(self, "scale", Vector3(0.75, 0.75, 0.75), 0.25)
		await change_scale.finished
		var preview = preview_character.instantiate()
		preview.transform = transform
		get_tree().root.add_child(preview)
		preview.spawned_character.connect(_on_preview_character_spawned_character)
	else:
		change_scale.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.25)
		split_character.queue_free()
	
	is_skill_on = !is_skill_on


func grow_character():
	var change_scale : Tween = get_tree().create_tween()
	var change_offset : Tween = get_tree().create_tween()

	if !is_skill_on:
		change_scale.tween_property($Temp_Body, "mesh:size", Vector3(0.5, 3, 0.5), 0.25)
		change_offset.tween_property($Temp_Body, "position:y", 1.5, 0.25)
	else:
		change_scale.tween_property($Temp_Body, "mesh:size", Vector3(0.75, 2, 0.75), 0.25)
		change_offset.tween_property($Temp_Body, "position:y", 1.0, 0.25)
	
	is_skill_on = !is_skill_on

func flatten_character():
	var change_scale : Tween = get_tree().create_tween()
	var change_offset : Tween = get_tree().create_tween()

	if !is_skill_on:
		change_scale.tween_property($Temp_Body, "mesh:size", Vector3(2, 1, 2), 0.25)
		change_offset.tween_property($Temp_Body, "position:y", 0.5, 0.25)
	else:
		change_scale.tween_property($Temp_Body, "mesh:size", Vector3(0.75, 2, 0.75), 0.25)
		change_offset.tween_property($Temp_Body, "position:y", 1.0, 0.25)
	
	is_skill_on = !is_skill_on


# func shrink_character():
# 	var change_scale : Tween = get_tree().create_tween()
# 	var change_offset : Tween = get_tree().create_tween()
	
# 	if !is_skill_on:
# 		change_scale.tween_property($Temp_Body, "mesh:height", 1.0, 0.25)
# 		change_offset.tween_property($Temp_Body, "position:y", 0.5, 0.25)
# 	else:
# 		change_scale.tween_property($Temp_Body, "mesh:height", 2.0, 0.25)
# 		change_offset.tween_property($Temp_Body, "position:y", 1.0, 0.25)
	
# 	is_skill_on = !is_skill_on
