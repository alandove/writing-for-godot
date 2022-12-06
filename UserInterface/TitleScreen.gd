extends TextureRect

onready var button := $Button
signal start_button

func _ready() -> void:
# warning-ignore:return_value_discarded
	button.connect("pressed", self, "_on_button_pressed")

func _on_button_pressed() -> void:
	print("Button pressed.")
	emit_signal("start_button")
