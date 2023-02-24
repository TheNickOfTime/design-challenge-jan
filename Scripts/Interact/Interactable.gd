extends Node3D
class_name Interactable


enum InteractState {OFF, ACTIVATED, INTERACTABLE} 

var interact_state : InteractState = InteractState.OFF

@onready var interact_area : Area3D = $Interact_Radius
@onready var activation_area : Area3D = $Proximity_Radius
@onready var label : Label3D = $Label3D


func _ready():
	interact_area.body_entered.connect(_on_interact_radius_enter)
	interact_area.body_exited.connect(_on_interact_radius_exit)
	activation_area.body_entered.connect(_on_activation_radius_enter)
	activation_area.body_exited.connect(_on_activation_radius_exit)

	set_state(InteractState.OFF)


func _on_interact_radius_enter(body : Node3D):
	if is_player(body):
		set_state(InteractState.INTERACTABLE)


func _on_interact_radius_exit(body : Node3D):
	if is_player(body):
		set_state(InteractState.ACTIVATED)


func _on_activation_radius_enter(body : Node3D):
	if is_player(body):
		set_state(InteractState.ACTIVATED)
		body.interactable = self


func _on_activation_radius_exit(body : Node3D):
	if is_player(body):
		set_state(InteractState.OFF)
		if body.interactable == self:
			body.interactable = null


func _on_interact(character : PlayerCharacter):
	pass


func set_state(new_state : InteractState):
	match new_state:
		InteractState.OFF:
			label.visible = false
		InteractState.ACTIVATED:
			label.visible = true
			label.text = "..."
		InteractState.INTERACTABLE:
			label.visible = true
			label.text = "F"
	
	interact_state = new_state


func set_interact_enabled(is_enabled : bool):
	if is_enabled:
		interact_area.monitoring = true
		activation_area.monitoring = true
	else:
		interact_area.monitoring = false
		activation_area.monitoring = false
		set_state(InteractState.OFF)


func is_player(body : Node3D) -> bool:
	return body == (Controller.current_character as Node3D)