extends Trigger


func trigger_entered(node : Node3D):
	if power_line != null:
		if !is_inverted:
			power_line.update_decal_colors(true, 0.25)
		else:
			power_line.update_decal_colors(false, 0.25)

	await get_tree().create_timer(0.25).timeout

	if node.is_in_group("Beam"):
		if !is_inverted:
			trigger_activated.emit()
		else:
			trigger_deactivated.emit()

func trigger_exited(node : Node3D):
	if power_line != null:
		if !is_inverted:
			power_line.update_decal_colors(false, 0.25)
		else:
			power_line.update_decal_colors(true, 0.25)

	if node.is_in_group("Beam"):
		if !is_inverted:
			trigger_deactivated.emit()
		else:
			trigger_activated.emit()