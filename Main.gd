extends Control

onready var title_screen = $TitleScreen
onready var director = $Director
#onready var button_bar : HBoxContainer = $Director/TextBox/ButtonBar

func _ready() -> void:
	# Start with the rest of the tree paused. `Main` has its pause mode set to `process` in the inspector. `Director`'s is set to `stop`, with all the nodes under it inheriting that.
	get_tree().paused = true
	title_screen.connect("start_button_pressed", self, "_on_MainMenu_start_button_pressed")
	title_screen.show()
# warning-ignore:return_value_discarded
	#button_bar.connect("option_chosen", self, "_on_option_chosen")
	director.connect("exit_requested", self, "_on_exit_requested")

func _on_MainMenu_start_button_pressed() -> void:
	get_tree().paused = false
	title_screen.hide()
	director.start_story()

func _on_exit_requested(option) -> void:
	if option == "exit":
		director.stop_story()
		get_tree().paused = true
		title_screen.show()
