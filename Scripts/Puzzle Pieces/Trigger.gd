extends Area3D
class_name Trigger

signal trigger_activated
signal trigger_deactivated

# @export var triggerables : Array[Triggerable]
@export var triggerable : Triggerable
@export var power_line : Node3D

var current_bodies : Array[PhysicsBody3D]


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if triggerable != null:
		trigger_activated.connect(triggerable._on_trigger_activated)
		trigger_deactivated.connect(triggerable._on_trigger_deactivated)

	if get_child_count() > 0:
		for child in get_children():
			if child is Relay:
				var relay : Relay = child
				trigger_activated.connect(relay._on_trigger_activated)
				trigger_deactivated.connect(relay._on_trigger_deactivated)


func _process(delta):
	pass


func _on_body_entered(body : Node3D):
	if body.is_in_group("Character"):
		print_debug(body.name + " has entered " + self.name)
		current_bodies.append(body)

		if current_bodies.size() == 1:
			trigger_entered()


func _on_body_exited(body : Node3D):
	if body.is_in_group("Character"):
		print_debug(body.name + " has exited " + self.name)
		current_bodies.erase(body)

		if current_bodies.size() <= 0:
			trigger_exited()


func trigger_entered():
	pass


func trigger_exited():
	pass
