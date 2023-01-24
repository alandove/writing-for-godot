# Display the game options at the bottom of the text box, and handle inputs from them.
extends HBoxContainer

# Sent when a player clicks an option button.
signal option_chosen(option_id)

# Establish the options.
var options : Array = ["save", "load", "exit", "next", "skip"]

onready var _timer : Timer = $SkipTimer

func _ready() -> void:
	display_options()
	# Connect the timer to the function that sends a "next" signal up to the TextBox, so we'll skip ahead as long as it's running.
# warning-ignore:return_value_discarded
	_timer.connect("timeout", self, "_on_SkipTimer_timeout")
	
func display_options() -> void:
	for option in options:
		var button := Button.new()
		button.text = option.capitalize()
		add_child(button)
# warning-ignore:return_value_discarded
		button.connect("button_down", self, "_on_Button_down", [option])
# warning-ignore:return_value_discarded
		button.connect("button_up", self, "_on_Button_up", [option])

# TODO: Implement the SkipButton code here, so we'll have a child timer and spam the "next" signal to keep the text advancing as long as it's held down. Add `_start_skipping` and `stop_skipping` functions.
func _on_SkipTimer_timeout() -> void:
	emit_signal("option_chosen", "next")

func _input(event: InputEvent) -> void:
	# This is how we process inputs. I've set "save" in the InputMap to be triggered by the "s" key, and `_on_Button_down` now converts pressing the onscreen "save" button into the same input, and so on, so all inputs (button or key) should end up here.
	for option in options:
		if event.is_action_pressed(option):
			print("The option pressed is ", option)
			# If the player is pressing "Skip," start skipping.
			if option == "skip":
				_timer.start()
			else:
				emit_signal("option_chosen", option)
		elif event.is_action_released(option):
			print("The option released is ", option)
			# If the player released the "Skip" button, stop skipping.
			if option == "skip":
				_timer.stop()
	# Release focus from the buttons.
	# TODO: This probably goes one indentation up, in the `is_action_released` block. 
	for child in get_children():
		if child is Button:
			child.release_focus()

func _on_Button_down(option) -> void:
	# Here's the code we need to convert a button press into an `InputEvent`, which will then be handled in the `_input` function if we've defined and named appropriate inputs in the InputMap settings.
	var a = InputEventAction.new()
	a.action = option
	a.pressed = true
	Input.parse_input_event(a)
	
func _on_Button_up(option) -> void:
	# Same as for _on_Button_down, but we're tracking button releases so we can process the "Skip" option properly.
	var a = InputEventAction.new()
	a.action = option
	a.pressed = false
	Input.parse_input_event(a)
