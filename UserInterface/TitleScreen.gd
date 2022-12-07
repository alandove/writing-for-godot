extends TextureRect

onready var start_button := $StartButton
onready var quit_button := $QuitButton
signal start_button_pressed

func _ready() -> void:
# warning-ignore:return_value_discarded
	start_button.connect("pressed", self, "_on_start_button_pressed")
# warning-ignore:return_value_discarded
	quit_button.connect("pressed", self, "_on_quit_button_pressed")
	start_button.grab_focus()

func _on_start_button_pressed() -> void:
	emit_signal("start_button_pressed")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
