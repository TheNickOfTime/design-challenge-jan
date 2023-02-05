extends Triggerable


@export var speed : float = 2.0
@export var direction : Vector3
@export var section_spacing : float = 0.1

var current_bodies : Array[PhysicsBody3D]
var conveyor_sections : Array[PathFollow3D]

@onready var conveyor_force : Vector3 = direction.normalized() * speed


func _ready():
	for child in $Path3D.get_children():
		if child is PathFollow3D:
			conveyor_sections.append(child)
	
	spawn_conveyor_sections()


func _process(delta):
	if is_activated:
		update_conveyor(delta)


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


func spawn_conveyor_sections():
	var conveyor_length : float = $Path3D.curve.get_baked_length()
	var sections_to_spawn : int = conveyor_length as int
	
	for i in sections_to_spawn:
		var new_section = $Path3D/Conveyor_Section_01.duplicate()
		new_section.progress = i
		conveyor_sections.append(new_section)
		$Path3D.add_child(new_section)
		


func update_conveyor(delta : float):
	for section in conveyor_sections:
		(section as PathFollow3D).progress += speed * delta
