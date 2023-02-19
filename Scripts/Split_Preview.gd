extends Area3D

signal spawned_character(character : Node)

@export var base_character : PackedScene

@onready var dummy_body : PhysicsBody3D = $Dummy_Body
@onready var original_col_mask : int = dummy_body.collision_mask
@onready var original_col_layer : int = dummy_body.collision_layer

func _on_body_exited(body:Node3D):
	if body.is_in_group("Character"):
		spawn_character()

func spawn_character():
	var new_character : PlayerCharacter = base_character.instantiate()
	new_character.transform = transform

	dummy_body.collision_mask = original_col_mask
	dummy_body.collision_layer = original_col_layer
	
	# await get_tree().physics_frame
	
	# dummy_body.queue_free()
	get_parent().add_child(new_character)
	await get_tree().physics_frame
	await get_tree().physics_frame
	spawned_character.emit(new_character)
	print("Spawned real character")
	queue_free()
