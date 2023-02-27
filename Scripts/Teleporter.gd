extends Node3D
class_name Teleporter


signal teleported

var is_active : bool
var current_bodies : Array[Node3D]

@onready var area_01 : Node3D = $Teleporter_Area_01
@onready var area_02 : Node3D = $Teleporter_Area_02


func _on_body_entered_area1 (body : Node3D):
	current_bodies.append(body)
	if !is_active:
		teleport_other_player(true)


func _on_body_entered_area2 (body : Node3D):
	current_bodies.append(body)
	if !is_active:
		teleport_other_player(false)


func _on_body_exited_area1 (body : Node3D):
	current_bodies.erase(body)
	if current_bodies.size() == 0:
		is_active = false


func _on_body_exited_area2 (body : Node3D):
	current_bodies.erase(body)
	if current_bodies.size() == 0:
		is_active = false


func teleport_other_player(is_area_one : bool):
	# Controller.can_move_character = false
	is_active = true
	var character : PlayerCharacter = Controller.other_character
	var new_transform = area_01.global_transform if !is_area_one else area_02.global_transform

	PhysicsSmoother.add_exclude_node(character)
	
	var scale_down_tween = get_tree().create_tween()
	scale_down_tween.tween_property(character, "scale", Vector3.ZERO, 0.25)

	await scale_down_tween.finished
	character.position = new_transform.origin
	character.transform.basis.z = -new_transform.basis.z

	for player in Controller.characters:
		if player.is_skill_on:
			player.primary_skill()
		if player is PlayerCharacter_Shift:
			if player.carried_item != null:
				player.carried_item.queue_free()
	
	await get_tree().create_timer(0.1).timeout

	var scale_up_tween = get_tree().create_tween()
	scale_up_tween.tween_property(character, "scale", Vector3.ONE, 0.25)

	PhysicsSmoother.remove_exclude_node(character)

	await scale_up_tween.finished
	teleported.emit()
	# Controller.can_move_character = true
