extends Control

onready var title_screen = $TitleScreen
onready var director = $Director
#onready var button_bar : HBoxContainer = $Director/TextBox/ButtonBar

# Pop-up dialog to confirm when a player wants to exit to the main screen.
onready var _pause_menu : TextureRect = $PauseMenu
onready var _pause_buttons : VBoxContainer = $PauseMenu/PauseButtons
# Get the options from the pause buttons.
onready var pause_options : Array = _pause_buttons.options

# Button bar for the main game controls.
onready var _button_bar : HBoxContainer = $Director/TextBox/ButtonBar

func _ready() -> void:
	# Start with the rest of the tree paused. `Main` has its pause mode set to `process` in the inspector. `Director`'s is set to `stop`, with all the nodes under it inheriting that.
	get_tree().paused = true
	_pause_menu.hide()

	title_screen.connect("start_button_pressed", self, "_on_MainMenu_start_button_pressed")
	title_screen.show()

#	director.connect("exit_requested", self, "_on_exit_requested")
	# warning-ignore:return_value_discarded
	_button_bar.connect("option_chosen", self, "_on_option_chosen")
	
# warning-ignore:return_value_discarded
	_pause_buttons.connect("pause_option_chosen", self, "_pause_option_chosen")
	
func _on_MainMenu_start_button_pressed() -> void:
	get_tree().paused = false
	title_screen.hide()
	director.start_story()

func _on_option_chosen(option) -> void:
	if option == "exit":
		director.stop_story()
		_pause_menu.show()
		get_tree().paused = true
		print("Main has received the `exit` signal.")
		
		# TODO: Fix this so keyboard controls go to the `ExitConfirmation`.

func _pause_option_chosen(option) -> void:
	match pause_options[option]:
		"quit":
			get_tree().quit()
		"cancel":
			get_tree().paused = false
			director.start_story()
	
#func _on_exit_cancelled() -> void:
#	_pause_menu.release_focus()
#	_pause_menu.hide()
#	get_tree().paused = false
#
#func _on_exit_confirmed() -> void:
#	emit_signal("exit_requested", "exit")
