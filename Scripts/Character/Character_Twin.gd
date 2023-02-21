extends PlayerCharacter
class_name PlayerCharacter_Twin

@onready var distance_label : Label3D = $Distance_Label

func update_distance_label(distance : float, is_in_range : bool):
	var label_string = "%2.1f" % distance
	# label_string = label_string % 


	distance_label.text = label_string + "m"
	distance_label.modulate = Color.WHITE if is_in_range else Color.DARK_RED