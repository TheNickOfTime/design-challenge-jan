extends Node3D
class_name Triggerable


@export var is_activated : bool = false
var activator_count : int = 0


func _ready():
	if is_activated:
		await get_tree().process_frame
		trigger_activated()


func _process(delta):
	pass


func _on_trigger_activated():
	activator_count += 1

	if activator_count == 1:
		trigger_activated()
		is_activated = true


func _on_trigger_deactivated():
	activator_count -= 1
	if activator_count == 0:
		trigger_deactivated()
		is_activated = false


func trigger_activated():
	print_debug("Activated")


func trigger_deactivated():
	print_debug("Deactivated")
