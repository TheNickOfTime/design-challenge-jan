extends CanvasLayer
class_name HUD


@onready var primary_input_button : Button = $InputPrompts/Primary/Button
@onready var primary_input_label : Label = $InputPrompts/Primary/Label

@onready var secondary_input_button : Button = $InputPrompts/Secondary/Button
@onready var secondary_input_label : Label = $InputPrompts/Secondary/Label


func _ready():
	pass


func set_input_labels (primary : String, secondary : String):
	primary_input_label.text = primary
	secondary_input_label.text = secondary


func set_input_enabled(primary : bool, secondary : bool):
	primary_input_button.disabled = !primary
	secondary_input_button.disabled = !secondary

	var primary_color : Color = Color.WHITE if primary else Color.WEB_GRAY
	var secondary_color : Color = Color.WHITE if secondary else Color.WEB_GRAY
	primary_input_label.add_theme_color_override("font_color", primary_color)
	secondary_input_label.add_theme_color_override("font_color", secondary_color)


func _on_controller_character_switch(character : PlayerCharacter):
	if character is PlayerCharacter_Shift:
		set_input_labels("Stretch", "Squash")
		set_input_enabled(true, true)
	elif character is PlayerCharacter_Divide:
		set_input_labels("Divide", "Command")


func _on_character_character_split(character : PlayerCharacter):
	if character is PlayerCharacter_Divide:
		if character.spawned_twin != null:
			set_input_enabled(true, true)
		else:
			if character.is_skill_on:
				set_input_enabled(false, false)
			else:
				set_input_enabled(true, false)
