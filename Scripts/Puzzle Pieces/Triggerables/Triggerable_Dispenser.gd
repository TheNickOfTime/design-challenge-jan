extends Triggerable


@export var cube : PackedScene

var spawned_cube : RigidBody3D

@onready var spawn_point : Node3D = $Spawn_Point


func _process(delta):
	if is_activated && spawned_cube == null:
		trigger_activated()


func trigger_activated():
	var old_cube : RigidBody3D = spawned_cube
	var new_cube : RigidBody3D = cube.instantiate()
	new_cube.freeze = true
	new_cube.global_position = spawn_point.global_position
	new_cube.scale = Vector3.ZERO
	get_parent().add_child(new_cube)
	spawned_cube = new_cube

	var cube_tween : Tween = get_tree().create_tween()
	cube_tween.tween_property(new_cube, "scale", Vector3.ONE, 0.25)

	await cube_tween.finished

	new_cube.freeze = false

	if old_cube != null:
		var old_cube_tween : Tween = get_tree().create_tween()
		old_cube_tween.tween_property(old_cube, "scale", Vector3.ZERO, 0.25)
		await old_cube_tween.finished
		old_cube.queue_free()


func trigger_deactivated():
	pass