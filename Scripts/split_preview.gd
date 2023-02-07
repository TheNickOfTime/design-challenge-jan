extends Area3D

signal spawned_character(character : Node)

@export var base_character : PackedScene


func _on_body_exited(body:Node3D):
	if body.is_in_group("Character"):
		spawn_character()

func spawn_character():
	var new_character : PlayerCharacter = base_character.instantiate()
	new_character.transform = transform
	$StaticBody3D.queue_free()

	await get_tree().process_frame

	get_parent().add_child(new_character)
	spawned_character.emit(new_character)
	print("Spawned real character")
	queue_free()