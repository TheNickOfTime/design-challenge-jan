extends Interactable


func _on_interact(character : PlayerCharacter):
	if self as Node3D is RigidBody3D:
		(self as Node3D as RigidBody3D).freeze = true

	var current_shrink_tween : Tween = get_tree().create_tween()
	current_shrink_tween.tween_property(self, "scale", Vector3.ZERO, 0.25)

	if character.carried_item != null:
		var previous_shrink_tween : Tween = get_tree().create_tween()
		previous_shrink_tween.tween_property(character.carried_item, "scale", Vector3.ZERO, 0.25)

	await current_shrink_tween.finished

	set_interact_enabled(false)
	await get_tree().physics_frame
	
	if character.carried_item != null:
		var initial_position = global_position
		character.carried_item.global_position = initial_position
	character.set_carried_item(self)

	var current_grow_tween : Tween = get_tree().create_tween()
	current_grow_tween.tween_property(self, "scale", Vector3.ONE, 0.25)

	if character.carried_item != null:
		var previous_grow_tween : Tween = get_tree().create_tween()
		previous_grow_tween.tween_property(character.carried_item, "scale", Vector3.ONE, 0.25)
	
	
