extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var navigation_agent = $NavigationAgent3D

@export var destination : Node3D

var movement_speed  : float = 4.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():	
	set_movement_target(destination.position)


func _physics_process(delta):
	var current_agent_position : Vector3 = global_transform.origin
	var next_path_position : Vector3 = navigation_agent.get_next_location()

	var new_velocity : Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	set_velocity(new_velocity)
	move_and_slide()


func set_movement_target(movement_target : Vector3):
	navigation_agent.set_target_location(movement_target)
