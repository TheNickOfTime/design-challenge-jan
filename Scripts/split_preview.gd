extends Area3D

signal spawned_character(character : Node)

@export var base_character : PackedScene


func _on_body_exited(body:Node3D):
    if body.is_in_group("Character"):
        spawn_character()

func spawn_character():
    var new_character = base_character.instantiate()
    new_character.transform = transform
    get_tree().root.add_child(new_character)
    spawned_character.emit(new_character)
    queue_free()