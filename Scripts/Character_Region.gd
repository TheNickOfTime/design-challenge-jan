extends Area3D
class_name CharacterRegion


# func _on_body_exited(body:Node3D):
# 	pass # Replace with function body.


func _on_body_entered(body:Node3D):
	if body is PlayerCharacter:
		var character = body as PlayerCharacter
		character.character_region = self
		Controller.check_character_regions()
