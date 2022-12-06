extends Control

onready var title_screen = $TitleScreen
onready var director = $Director

func _ready() -> void:
# warning-ignore:return_value_discarded
#	get_tree().change_scene_to(title_screen)
	title_screen.connect("start_button", self, "_on_MainMenu_start_game")
	title_screen.show()

func _on_MainMenu_start_game() -> void:
	print("Button press signal received.")
	title_screen.hide()
	director.start_story()
