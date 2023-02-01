extends Trigger


@onready var button_anim : AnimationPlayer = $AnimationPlayer


func _ready():
	super() # Call OG Ready func


func trigger_entered():
	button_anim.play("button_down")

	await button_anim.animation_finished

	trigger_activated.emit()

func trigger_exited():
	button_anim.play_backwards("button_down")

	await button_anim.animation_finished

	trigger_deactivated.emit()
