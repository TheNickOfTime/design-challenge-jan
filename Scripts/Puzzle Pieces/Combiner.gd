extends Triggerable
class_name Combiner


signal combiner_activated
signal combiner_deactivated

@export var triggerable : Triggerable
@export var power_line : PowerLine

var triggers : Array[Trigger]
var active_trigger_count : int


func _ready():
	super()
	for child in get_children():
		if child is Trigger:
			triggers.append(child)
	
	combiner_activated.connect(triggerable._on_trigger_activated)
	combiner_deactivated.connect(triggerable._on_trigger_deactivated)


func _on_trigger_activated():
	activator_count += 1
	check_triggers()


func _on_trigger_deactivated():
	activator_count -= 1
	check_triggers()


func trigger_activated():
	# active_trigger_count += 1
	check_triggers()


func trigger_deactivated():
	# active_trigger_count -= 1
	check_triggers()


func check_triggers():
	if activator_count == triggers.size():
		if !triggerable.is_activated:
			combiner_activated.emit()
			if power_line != null:
				power_line.update_decal_colors(true, 0.25)
	else:
		if triggerable.is_activated:
			combiner_deactivated.emit()
			if power_line != null:
				power_line.update_decal_colors(false, 0.25)