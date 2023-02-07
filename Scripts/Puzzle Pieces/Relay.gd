extends Node
class_name Relay


signal relay_activated
signal relay_deactivated

@export var triggerable : Triggerable
@export var power_line : PowerLine


func _ready():
	if triggerable != null:
		relay_activated.connect(triggerable._on_trigger_activated)
		relay_deactivated.connect(triggerable._on_trigger_deactivated)


func _on_trigger_activated():
	relay_activated.emit()
	power_line.update_decal_colors(true, 0.25)


func _on_trigger_deactivated():
	relay_deactivated.emit()
	power_line.update_decal_colors(false, 0.25)
