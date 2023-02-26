extends Node3D


@export var type : PlayerCharacter.CHARACTER_SKILL

var shift_character : PackedScene = preload("res://Prefab/Character/character_shift.tscn")
var divide_character : PackedScene = preload("res://Prefab/Character/character_divide.tscn")


func _enter_tree():
	get_child(0).queue_free()

	await get_tree().process_frame

	match type:
		PlayerCharacter.CHARACTER_SKILL.SHIFT:
			if Controller.characters[0] == null:
				var character = shift_character.instantiate()
				character.transform = global_transform
				get_tree().root.add_child(character)
				Controller.characters[0] = character
		PlayerCharacter.CHARACTER_SKILL.DIVIDE:
			if Controller.characters[1] == null:
				var character = divide_character.instantiate()
				character.transform = global_transform
				get_tree().root.add_child(character)
				Controller.characters[1] = character
