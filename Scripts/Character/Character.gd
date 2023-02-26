extends CharacterBody3D
class_name PlayerCharacter


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum CONTROL_STATE {NONE, INPUT, NAVIGATION}
enum CHARACTER_SKILL {NONE, SHIFT, DIVIDE}

# On Ready Vars-------------------------------------------------------------------------------------
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var default_camera_offset : Vector3 = camera_offset

# Member Vars---------------------------------------------------------------------------------------
var control_state : CONTROL_STATE
var is_skill_on : bool

var move_direction : Vector2
var move_speed : float = 5.0
var rotate_speed : float = 1
var rotate_direction : Vector2
var additional_forces : Vector3

var camera_offset : Vector3 = Vector3(0, 1.8, 0)

var nav_destination : Vector3

var can_move : bool = true
var can_use_skill : bool = true

var character_region : CharacterRegion

var interactable : Interactable

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
			# velocity = velocity + additional_forces
			move_and_slide()
		CONTROL_STATE.INPUT:
			move_input(move_direction, delta)
		CONTROL_STATE.NAVIGATION:
			move_nav()


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
		look_at(Vector3(next_position.x, position.y, next_position.z))
	else:
		velocity = Vector3.ZERO
	
	velocity += additional_forces
	move_and_slide()


func rotate_character(delta : float):
	rotate_y(rotate_direction.x * -0.25 * delta)
	# print(rotation)


func set_new_nav_destination(new_destination : Vector3):
	nav_destination = new_destination
	nav_agent.target_position = new_destination


# Character Skills----------------------------------------------------------------------------------
func primary_skill():
	printerr("This needs to be overridden to have any functionality")


func secondary_skill():
	printerr("This needs to be overridden to have any functionality")


func interact():
	if interactable != null:
		interactable._on_interact(self)
