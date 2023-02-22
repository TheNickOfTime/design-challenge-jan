extends Triggerable


@export var move_distance : float = 2
@export var move_speed : float = 2
@export var move_direction : Vector3 = Vector3(0, 1, 0)
@export var platform : StaticBody3D

var last_tween : Tween


func trigger_activated():
	tween_platform(true)


func trigger_deactivated():
	tween_platform(false)


func tween_platform(is_up : bool):
	if last_tween != null:
		last_tween.stop()
	
	var tween : Tween = get_tree().create_tween()
	var destination : Vector3 = move_direction.normalized() * move_distance if is_up else Vector3.ZERO
	var tween_time : float = destination.distance_to(platform.position) / move_speed

	tween.tween_property(platform, "position", destination, tween_time)
	
	last_tween = tween
