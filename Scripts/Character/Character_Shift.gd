extends PlayerCharacter
class_name PlayerCharacter_Shift


@onready var anim_player : AnimationPlayer = $AniamtionPlayer


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