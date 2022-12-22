# Display the game options at the bottom of the text box, and handle inputs from them.
extends HBoxContainer

# Sent when a player clicks an option button.
signal option_chosen(option_id)

# Establish the options.
var options : Array = ["save", "load", "exit", "next", "skip"]

func _ready() -> void:
	display_options()
	
func display_options() -> void:
	for option in options:
		var button := Button.new()
		button.text = option.capitalize()
		add_child(button)
# warning-ignore:return_value_discarded
		button.connect("pressed", self, "_on_Button_pressed", [option])

func _on_Button_pressed(option) -> void:
	# Here's the code we need to convert a button press into an `InputEvent`, which will then be handled in the `_input` function if we've defined and named appropriate inputs in the InputMap settings.
	var a = InputEventAction.new()
	a.action = option
	a.pressed = true
	Input.parse_input_event(a)
	
	# Release focus from the buttons.
	for child in get_children():
		if child is Button:
			child.release_focus()
	print("Option number ", options.find(option), " called ", option, ", or capitalized ", option.capitalize(), " chosen.")

func _input(event: InputEvent) -> void:
	# This is how we process inputs. I've set "save" in the InputMap to be triggered by the "s" key, and `_on_Button_pressed` now converts pressing the "save" button into the same input, and so on, so all inputs (button or key) should end up here.
	for option in options:
		if event.is_action_pressed(option):
			print("The option pressed is ", option)
			emit_signal("option_chosen", option)
