extends Trigger


@onready var button_anim : AnimationPlayer = $AnimationPlayer


func _ready():
	super() # Call OG Ready func


func trigger_entered(node : Node3D):
	button_anim.play("button_down")
	
	if power_line != null:
		power_line.update_decal_colors(true, button_anim.current_animation_length)

	await button_anim.animation_finished

	if !is_inverted:
		trigger_activated.emit()
	else:
		trigger_deactivated.emit()

func trigger_exited(node : Node3D):
	button_anim.play_backwards("button_down")
	
	if power_line != null:
		power_line.update_decal_colors(false, button_anim.current_animation_length)

	# await button_anim.animation_finished

	if !is_inverted:
		trigger_deactivated.emit()
	else:
		trigger_activated.emit()
