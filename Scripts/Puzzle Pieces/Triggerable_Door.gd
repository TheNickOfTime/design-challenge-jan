extends Triggerable


@onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready():
	super()
	$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate()


func trigger_activated():
	animation_player.play("door_up")


func trigger_deactivated():
	animation_player.play_backwards("door_up")