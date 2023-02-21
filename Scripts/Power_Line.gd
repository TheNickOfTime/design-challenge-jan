@tool
extends Path3D
class_name PowerLine


const decal_spacing : float = 1

@export var decal : PackedScene
@export var activated_color : Color
@export var deactivated_color : Color

var decals : Array[Decal]


func _enter_tree():
#	curve = curve.duplicate()
	curve_changed.connect(_on_curve_changed)
	update_decals()


func _exit_tree():
	pass


func _on_curve_changed():
	update_decals()


func update_decals():
	for item in get_children():
		item.queue_free()
	
	decals.clear()

	for i in (curve.get_baked_length() / decal_spacing + 1) as int:
		var new_decal = decal.instantiate()
		new_decal.transform = curve.sample_baked_with_rotation(i / decal_spacing)
		new_decal.modulate = deactivated_color
		decals.append(new_decal)
		add_child(new_decal)


func update_decal_colors(is_activated : bool, time : float):
	if !is_activated:
		decals.reverse()
	
	var color : Color = activated_color if is_activated else deactivated_color
	var time_per :float = time / decals.size()

	for item in decals:
		item.modulate = color
		await get_tree().create_timer(time_per).timeout
	
	if !is_activated:
		decals.reverse()
