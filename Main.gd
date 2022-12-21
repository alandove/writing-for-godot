extends Control

onready var title_screen = $TitleScreen
onready var director = $Director

func _ready() -> void:
	# Start with the rest of the tree paused. `Main` has its pause mode set to `process` in the inspector. `Director`'s is set to `stop`, with all the nodes under it inheriting that.
	get_tree().paused = true
	title_screen.connect("start_button_pressed", self, "_on_MainMenu_start_button_pressed")
	title_screen.show()

func _on_MainMenu_start_button_pressed() -> void:
	get_tree().paused = false
	title_screen.hide()
	director.start_story()
