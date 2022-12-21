# Display the game options at the bottom of the text box, and handle inputs from them.
extends HBoxContainer

# Sent when a player clicks an option button.
signal option_chosen(option_id)

# Establish the options.
enum Options {
	SAVE,
	LOAD,
	EXIT,
	SKIP,
}

func _ready() -> void:
	display_options()
	
func display_options() -> void:
	for option in Options:
		var button := Button.new()
		button.text = option.capitalize()
		add_child(button)
#		button.set_focus_mode(Control.FOCUS_ALL)
# warning-ignore:return_value_discarded
		button.connect("pressed", self, "_on_Button_pressed", [option])
		print("The SAVE option is number ", Options.SAVE)

func _on_Button_pressed(option) -> void:
	emit_signal("option_chosen", option)
	print("Option number ", Options.get(option), " called ", option, " chosen.")
