extends Area3D
class_name Trigger

signal trigger_activated
signal trigger_deactivated

enum TriggerMethod {BODY, AREA}

# @export var triggerables : Array[Triggerable]
@export var is_inverted : bool
@export var triggerable : Triggerable
@export var power_line : Node3D

@export var trigger_method : TriggerMethod
var current_bodies : Array[PhysicsBody3D]


func _ready():
	match trigger_method:
		TriggerMethod.BODY:
			body_entered.connect(_on_body_entered)
			body_exited.connect(_on_body_exited)
		TriggerMethod.AREA:
			area_entered.connect(_on_area_entered)
			area_exited.connect(_on_area_exited)

	if triggerable != null:
		trigger_activated.connect(triggerable._on_trigger_activated)
		trigger_deactivated.connect(triggerable._on_trigger_deactivated)
		triggerable.is_inverted = is_inverted

	if get_child_count() > 0:
		for child in get_children():
			if child is Relay:
				var relay : Relay = child
				trigger_activated.connect(relay._on_trigger_activated)
				trigger_deactivated.connect(relay._on_trigger_deactivated)


func _process(delta):
	pass


func _on_body_entered(body : Node3D):
	if body.is_in_group("Character") or body.is_in_group("Foreground"):
		print_debug(body.name + " has entered " + self.name + str(get_tree().get_frame()))
		current_bodies.append(body)

		if current_bodies.size() == 1:
			trigger_entered(body as Node3D)


func _on_body_exited(body : Node3D):
	if body.is_in_group("Character") or body.is_in_group("Foreground"):
		print_debug(body.name + " has exited " + self.name + str(get_tree().get_frame()))
		current_bodies.erase(body)

		if current_bodies.size() <= 0:
			trigger_exited(body as Node3D)


func _on_area_entered(area : Area3D):
	print_debug(area.name + " has entered " + self.name)
	trigger_entered(area as Node3D)


func _on_area_exited(area : Area3D):
	print_debug(area.name + " has exited " + self.name)
	trigger_exited(area as Node3D)



func trigger_entered(node : Node3D):
	pass


func trigger_exited(node : Node3D):
	pass
