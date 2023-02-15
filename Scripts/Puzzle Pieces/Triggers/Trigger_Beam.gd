extends Trigger


func trigger_entered(node : Node3D):
	if power_line != null:
		power_line.update_decal_colors(true, 0.25)

	await get_tree().create_timer(0.25).timeout

	if node.is_in_group("Beam"):
		trigger_activated.emit()

func trigger_exited(node : Node3D):
	if power_line != null:
		power_line.update_decal_colors(false, 0.25)

	if node.is_in_group("Beam"):
		trigger_deactivated.emit()