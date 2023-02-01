extends Area3D
class_name Trigger

signal trigger_activated
signal trigger_deactivated

# @export var triggerables : Array[Triggerable]
@export var triggerable : Triggerable


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# for triggerable in triggerables:
	# 	trigger_activated.connect(triggerable._on_trigger_activated())
	# 	trigger_deactivated.connect(triggerable._on_trigger_deactivated())

	trigger_activated.connect(triggerable._on_trigger_activated)
	trigger_deactivated.connect(triggerable._on_trigger_deactivated)


func _process(delta):
	pass


func _on_body_entered(body : Node3D):
	if body.is_in_group("Character"):
		trigger_entered()


func _on_body_exited(body : Node3D):
	if body.is_in_group("Character"):
		trigger_exited()


func trigger_entered():
	pass


func trigger_exited():
	pass
