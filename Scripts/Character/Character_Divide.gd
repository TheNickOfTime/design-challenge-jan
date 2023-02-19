extends PlayerCharacter
class_name PlayerCharacter_Divide


signal character_split(character : PlayerCharacter)

@export var twin_character : PackedScene
@export var decoy_character : PackedScene
@export var preview_character : PackedScene

var spawned_twin : Node3D
var twin_destination : Vector3


func _on_preview_character_spawned_character(spawned_character : Node3D):
	spawned_twin = spawned_character
	spawned_twin.control_state = PlayerCharacter.CONTROL_STATE.NAVIGATION
	character_split.emit(self)


func primary_skill():
	divide_character()


func secondary_skill():
	command_twin()


func divide_character():
	if !is_skill_on && can_use_skill:
		can_move = false
		can_use_skill = false

		# Store initial transform
		var starting_trans : Transform3D = transform
		# var starting_pos : Vector3 = position

		# Spawn decoy body to cover up transitions
		var decoy_body = decoy_character.instantiate()
		decoy_body.transform = starting_trans
		get_parent().add_child(decoy_body)

		# Spawn dummy character
		var dummy_character = preview_character.instantiate()
		dummy_character.transform = starting_trans
		dummy_character.name = "Character_Dummy"
		dummy_character.spawned_character.connect(_on_preview_character_spawned_character)
		get_parent().add_child(dummy_character)
		
		PhysicsSmoother.add_exclude_node(self)
		await get_tree().physics_frame

		# Move original character up
		$Temp_Body.mesh.height = 1.0
		$Temp_Body.position.y = 0.5
		$CollisionShape3D.shape.height = 1.0
		$CollisionShape3D.position.y = 0.5
		
		var tween_position = get_tree().create_tween()
		var tween_camera_offset = get_tree().create_tween()
		var new_camera_offset = Vector3(0, 0.8, 0)
		tween_position.tween_property(self, "position", position + Vector3.UP, 0.25)
		tween_camera_offset.tween_property(self, "camera_offset", new_camera_offset, 0.25)
		await tween_position.finished

		await get_tree().physics_frame
		PhysicsSmoother.remove_exclude_node(self)

		dummy_character.dummy_body.collision_layer = self.collision_layer
		dummy_character.dummy_body.collision_mask = self.collision_mask

		var tween_body_scale = get_tree().create_tween()
		tween_body_scale.tween_property(decoy_body, "scale", Vector3.ZERO, 0.25)

		is_skill_on = true

		character_split.emit(self)
		await tween_body_scale.finished
		decoy_body.queue_free()
		
		can_move = true
		can_use_skill = true
	elif spawned_twin != null:
		can_use_skill = false

		var change_height : Tween = get_tree().create_tween()
		var change_offset : Tween = get_tree().create_tween()
		var change_col_height : Tween = get_tree().create_tween()
		var change_col_offset : Tween = get_tree().create_tween()
		var change_dummy_scale : Tween = get_tree().create_tween()
		var tween_camera_offset = get_tree().create_tween()
		var new_camera_offset = default_camera_offset
		tween_camera_offset.tween_property(self, "camera_offset", new_camera_offset, 0.25)
		change_height.tween_property($Temp_Body, "mesh:height", 2.0, 0.25)
		change_offset.tween_property($Temp_Body, "position:y", 1.0, 0.25)
		change_col_height.tween_property($CollisionShape3D, "shape:height", 2, 0.25)
		change_col_offset.tween_property($CollisionShape3D, "position:y", 1.0, 0.25)
		change_dummy_scale.tween_property(spawned_twin, "scale", Vector3.ZERO, 0.25)
		await change_dummy_scale.finished
		spawned_twin.queue_free()
		spawned_twin = null
		is_skill_on = false
		character_split.emit(self)
		can_use_skill = true


func command_twin():
	if is_skill_on and spawned_twin != null:
		(spawned_twin as PlayerCharacter).set_new_nav_destination(twin_destination)
	else:
		pass
