extends Node3D


@export_file("*.tscn") var level_to_load : String

@onready var door_01 : Triggerable = $Triggerable_Door_01
@onready var door_02 : Triggerable = $Triggerable_Door_02
@onready var teleporter : Teleporter = $Teleporter


func _ready():
	teleporter.teleported.connect(_on_teleporter_teleported)
	door_01.trigger_activated()
	
	
func _on_teleporter_teleported():
	door_01.trigger_deactivated()

	# LevelLoader.finished_loading.connect(_on_level_loader_finished_loading)
	LevelLoader.load_level(level_to_load)
	await LevelLoader.finished_loading

	var next_level : Node3D = LevelLoader.current_level
	# next_level.global_transform = spawn_point.global_transform
	get_parent().add_child(next_level)

	door_02.trigger_activated()


func _on_level_loader_finished_loading(level_resource : PackedScene):
	pass
