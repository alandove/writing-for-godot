extends Control

onready var title_screen = $TitleScreen
onready var director = $Director

func _ready() -> void:
	title_screen.connect("start_button_pressed", self, "_on_MainMenu_start_button_pressed")
	title_screen.show()

func _on_MainMenu_start_button_pressed() -> void:
		title_screen.hide()
		director.start_story()
