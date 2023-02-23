extends Triggerable

@onready var beam : Area3D = $Beam
@onready var beam_mesh : MeshInstance3D = $Beam/MeshInstance3D
@onready var beam_col : CollisionShape3D = $Beam/CollisionShape3D
@onready var raycast : RayCast3D = $RayCast3D
@onready var beam_offset : Vector3 = beam.position


var beam_end_point : Vector3
var beam_length : float
var beam_center : float
var can_update_immediate : bool = true


func _ready():
	super()

	await get_tree().create_timer(0.1).timeout

	if is_activated:
		set_beam(true)
	else:
		set_beam(false)


func _process(delta):
	# print(raycast.get_collider())

	if is_activated and can_update_immediate:
		update_beam_parameters()
		update_beam_immediate()


func trigger_activated():
	set_beam(true)


func trigger_deactivated():
	set_beam(false)


func set_beam(is_active : bool):
	is_activated = is_active

	raycast.enabled = is_activated

	if is_activated:
		update_beam_parameters()
		beam.visible = is_activated
		update_beam_progress()
	else:
		beam_end_point = beam_offset
		beam_length = 0
		beam_center = 0

		await update_beam_progress()

		beam.visible = is_activated
	

func update_beam_parameters():
	beam_end_point = raycast.get_collision_point()
	beam_length = beam_end_point.distance_to(global_position + beam_offset) 
	beam_center = beam_length / 2
	# print(raycast.get_collider())


func update_beam_immediate():
	beam_mesh.mesh.size.z = beam_length
	beam_col.shape.size.z = beam_length
	beam.position.z = beam_center + beam_offset.z


func update_beam_progress():
	var tween_mesh : Tween = get_tree().create_tween()
	var tween_col : Tween = get_tree().create_tween()
	var tween_offset : Tween = get_tree().create_tween()

	tween_mesh.tween_property(beam_mesh, "mesh:size:z", beam_length, 0.25)
	tween_col.tween_property(beam_col, "shape:size:z", beam_length, 0.25)
	tween_offset.tween_property(beam, "position:z", beam_center + beam_offset.z, 0.25)

	can_update_immediate = false
	await tween_mesh.finished
	can_update_immediate = true