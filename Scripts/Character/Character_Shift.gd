extends PlayerCharacter
class_name PlayerCharacter_Shift


var carried_item : Node3D

@onready var anim_player : AnimationPlayer = $AniamtionPlayer
@onready var carry_point : Node3D = $Carry_Point


func primary_skill():
	shape_shift(true)


func secondary_skill():
	shape_shift(false)


func shape_shift(is_grow : bool):

	var anim_tree : AnimationTree = $AnimationTree
	var target_blend : float = (1 if is_grow else -1) if !is_skill_on else 0

	var tween_blend : Tween = get_tree().create_tween()
	tween_blend.tween_property(anim_tree, "parameters/blend_position", target_blend, 0.25)

	is_skill_on = !is_skill_on


func interact():
	if interactable != null:
		interactable._on_interact(self)
	elif carried_item != null:
		drop_carried_item()


func set_carried_item(item : Node3D):
	item.get_parent().remove_child(item)
	carry_point.add_child(item)

	item.position = Vector3.ZERO
	item.rotation = Vector3.ZERO

	if item is RigidBody3D:
		item.freeze = true

	carried_item = item


func drop_carried_item():
	var shrink_tween : Tween = get_tree().create_tween()
	shrink_tween.tween_property(carried_item, "scale", Vector3.ZERO, 0.25)
	
	await shrink_tween.finished
	carry_point.remove_child(carried_item)
	get_parent().add_child(carried_item)
	carried_item.global_position = global_position + basis.z * -1.5
	carried_item.global_position.y += 2

	var grow_tween : Tween = get_tree().create_tween()
	grow_tween.tween_property(carried_item, "scale", Vector3.ONE, 0.25)
	
	if carried_item is Interactable:
		print("shitty")
		carried_item.set_interact_enabled(true)

	if carried_item is RigidBody3D:
		carried_item.freeze = false
	
	carried_item = null