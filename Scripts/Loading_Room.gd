extends Node3D


@export_file("*.tscn") var level_to_load : String

var player_count : int = 0

@onready var door_01 : Triggerable = $Triggerable_Door_01
@onready var door_02 : Triggerable = $Triggerable_Door_02
@onready var teleporter : Teleporter = $Teleporter
@onready var area : Area3D = $Area3D


func _ready():
	teleporter.teleported.connect(_on_teleporter_teleported)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	door_01.trigger_activated()
	
	
func _on_teleporter_teleported():
	door_01.trigger_deactivated()

	# LevelLoader.finished_loading.connect(_on_level_loader_finished_loading)
	# LevelLoader.current_level.process_mode = Node.PROCESS_MODE_DISABLED
	# await get_tree().physics_frame
	LevelLoader.load_level(level_to_load)
	await LevelLoader.level_loaded
	await (door_01.get_node("AnimationPlayer") as AnimationPlayer).animation_finished

	# var next_level : Node3D = LevelLoader.current_level
	# # next_level.global_transform = spawn_point.global_transform
	# get_parent().add_child(next_level)

	door_02.trigger_activated()


func _on_level_loader_finished_loading(level_resource : PackedScene):
	pass


func _on_body_entered(body : Node3D):
	if body is PlayerCharacter:
		player_count += 1


func _on_body_exited(body : Node3D):
	if body is PlayerCharacter:
		player_count -= 1

		if player_count <= 0:
			door_02.reparent(LevelLoader.current_level)
			door_02.trigger_deactivated()
			await (door_02.get_node("AnimationPlayer") as AnimationPlayer).animation_finished
			queue_free()