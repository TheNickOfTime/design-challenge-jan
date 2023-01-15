extends CharacterBody3D
class_name PlayerCharacter


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var move_direction : Vector2

var rotate_speed : float = 1
var rotate_direction : Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	rotate_character(delta)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move(move_direction)

func move(move_direction : Vector2):
	var direction = (transform.basis * Vector3(move_direction.x, 0, move_direction.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func rotate_character(delta : float):
	rotate_y(rotate_direction.x * -0.25 * delta)
	pass
