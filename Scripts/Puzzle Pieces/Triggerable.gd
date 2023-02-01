extends Node
class_name Triggerable


func _ready():
	pass


func _process(delta):
	pass


func _on_trigger_activated():
	print_debug("Activated")

func _on_trigger_deactivated():
	print_debug("Deactivated")
