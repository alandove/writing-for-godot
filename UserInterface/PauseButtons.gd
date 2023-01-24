extends VBoxContainer

export var options: Array = ["save", "load", "quit", "cancel"]

signal pause_option_chosen(target_id)

# TODO: This should be based on the design of ChoiceSelector: when the player hits Esc or clicks "Pause," we'll have the `Director` make the `PauseMenu` scene appear. Then we need to tell `PauseButtons` to generate the options as buttons, and send a signal up when the player picks one. Once the `Director` gets that signal, it processes it and hides the `PauseMenu` again.

# Called when the node enters the scene tree for the first time.
func _ready():
	for option in options:
		var option_index := 0
		var button := Button.new()
		button.text = option.capitalize()
		option_index = options.find(option, 0)
		add_child(button)
		button.set_focus_mode(Control.FOCUS_ALL)
# warning-ignore:return_value_discarded
		button.connect("pressed", self, "_on_Button_pressed", [option_index])

func _input(event: InputEvent) -> void:
	# Grab keyboard focus on the buttons when the user presses Tab.
	if event.is_action_pressed("ui_focus_next"):
		if get_child_count() >= 1:
			(get_child(0) as Button).grab_focus()

func _on_Button_pressed(target_id) -> void:
	print("The PauseButtons are sending the signal 'pause_option' with the argument ", target_id)
	emit_signal("pause_option_chosen", target_id)
	for child in get_children():
		child.queue_free()

# Code pasted from `ChoiceSelector` for reference here, since we can't have split screen in the Godot editor.
#func display(choices: Array) -> void:
#	for choice in choices:
#		var choice_index := 0
#		var button := Button.new()
#		button.text = choice
#		choice_index = choices.find(choice,0)
#		add_child(button)
#		button.set_focus_mode(Control.FOCUS_ALL)
## warning-ignore:return_value_discarded
#		button.connect("pressed", self, "_on_Button_pressed", [choice_index])
#
#func _input(event: InputEvent) -> void:
#	# Grab keyboard focus on the buttons when the user presses the Tab key.
#	if event.is_action_pressed("ui_focus_next"):
#		if get_child_count() >= 1:
#			(get_child(0) as Button).grab_focus() # For reasons I can't figure out, this will highlight the second button even though it should highlight the first. But at least keyboard control works.
#
## When the player clicks on a choice, send the `choice_made` signal and the index of the choice they made.
#func _on_Button_pressed(target_id) -> void:
#	emit_signal("choice_made", target_id)
#	for child in get_children():
#		child.queue_free()
