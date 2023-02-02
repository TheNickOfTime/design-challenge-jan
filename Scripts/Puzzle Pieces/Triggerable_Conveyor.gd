extends Triggerable


@export var speed : float = 2.0
@export var direction : Vector3

var current_bodies : Array[PhysicsBody3D]

@onready var conveyor_force : Vector3 = direction.normalized() * speed


func _on_body_entered(body : Node3D):
	if body.is_in_group("Character"):
		current_bodies.append(body)
	
	if is_activated:
		set_additional_forces(body, conveyor_force)


func _on_body_exited(body : Node3D):
	if current_bodies.has(body):
		current_bodies.erase(body)
	
	set_additional_forces(body, Vector3.ZERO)


func trigger_activated():
	for body in current_bodies:
		set_additional_forces(body, conveyor_force)


func trigger_deactivated():
	for body in current_bodies:
		set_additional_forces(body, Vector3.ZERO)


func set_additional_forces(body : PhysicsBody3D, forces : Vector3):
	if body is PlayerCharacter:
		body.additional_forces = forces
	elif body is RigidBody3D:
		body.constant_force = forces
	else:
		printerr("Currently not accounting for other kinds of phsyics bodies")