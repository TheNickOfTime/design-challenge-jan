extends Node3D
class_name Triggerable


@export var is_activated : bool = false


func _ready():
	if is_activated:
		trigger_activated()


func _process(delta):
	pass


func _on_trigger_activated():
	trigger_activated()
	is_activated = true


func _on_trigger_deactivated():
	trigger_deactivated()
	is_activated = false


func trigger_activated():
	print_debug("Activated")


func trigger_deactivated():
	print_debug("Deactivated")