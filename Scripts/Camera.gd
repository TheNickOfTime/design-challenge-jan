extends SpringArm3D
class_name PlayerCamera


var character : CharacterBody3D
var offset : Vector3 = Vector3(0, 1.8, 0)
var mouse_delta : Vector2
var pan_speed : float = 0.25
var pan_direction : int = -1
var max_angle : float = 30


func _ready():
	pass


func _process(delta):
	follow_camera(delta)
	rotate_camera(delta)


func follow_camera(delta : float):
	position = character.position + offset


func rotate_camera(delta : float):
	rotate_y(mouse_delta.x * pan_direction * pan_speed * delta)
	rotate_object_local(Vector3.RIGHT, mouse_delta.y * pan_direction * pan_speed * delta)
	rotation.x = clamp(rotation.x, deg_to_rad(-max_angle), deg_to_rad(max_angle))
