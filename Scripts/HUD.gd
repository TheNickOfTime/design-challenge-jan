extends CanvasLayer
class_name HUD


@onready var primary_input_button : Button = $InputPrompts/Primary/Button
@onready var primary_input_label : Label = $InputPrompts/Primary/Label

@onready var secondary_input_button : Button = $InputPrompts/Secondary/Button
@onready var secondary_input_label : Label = $InputPrompts/Secondary/Label

@onready var switch_prompt_button : Button = $SwitchPrompt/Button
@onready var switch_prompt_label : Label = $SwitchPrompt/Label

@onready var interact_prompt : Control = $InteractPrompt


func _ready():
	Controller.hud = self


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

func set_switch_enabled(is_enabled : bool):
	switch_prompt_button .disabled = !is_enabled
	switch_prompt_label.add_theme_color_override("font_color", Color.WHITE if is_enabled else Color.WEB_GRAY)


func _on_controller_character_switch(character : PlayerCharacter):
	if character is PlayerCharacter_Shift:
		set_input_labels("Stretch", "Squash")
		set_input_enabled(true, true)
		interact_prompt.visible = true
	elif character is PlayerCharacter_Divide:
		set_input_labels("Divide", "Command")
		interact_prompt.visible = false



func _on_character_character_split(character : PlayerCharacter):
	if character is PlayerCharacter_Divide:
		if character.spawned_twin != null:
			set_input_enabled(true, true)
			set_input_labels("Rejoin", "Command")
		else:
			if character.is_skill_on:
				set_input_enabled(false, false)
			else:
				set_input_enabled(true, false)
			
				set_input_labels("Divide", "Command")


func _on_character_region_changed(is_same_region : bool):
	set_switch_enabled(is_same_region)


func _on_twin_out_of_range(is_in_range : bool):
	set_input_enabled(is_in_range, !secondary_input_button.disabled)
