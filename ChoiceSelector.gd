# Displays a list of choices the player can select from.
class_name ChoiceSelector
extends VBoxContainer

## Emitted when the player presses a choice button.
signal choice_made(target_id)

# We get choices as an array and create a button for each of them.
func display(choices: Array) -> void:
	for choice in choices:
		var choice_index := 0
		var button := Button.new()
		button.text = choice
		choice_index = choices.find(choice,0)
		add_child(button)
		button.set_focus_mode(Control.FOCUS_ALL)
# warning-ignore:return_value_discarded
		button.connect("pressed", self, "_on_Button_pressed", [choice_index])

func _input(event: InputEvent) -> void:
	# Grab keyboard focus on the buttons when the user presses the Tab key.
	if event.is_action_pressed("ui_focus_next"):
		(get_child(0) as Button).grab_focus() # For reasons I can't figure out, this will highlight the second button even though it should highlight the first. But at least keyboard control works.
	
# When the player clicks on a choice, send the `choice_made` signal and the index of the choice they made.
func _on_Button_pressed(target_id) -> void:
	emit_signal("choice_made", target_id)
	for child in get_children():
		child.queue_free()
