extends Button

## Emitted when the DelayTimer times out.
signal timer_ticked

onready var _timer := $DelayTimer

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("button_down", self, "_on_button_down")
# warning-ignore:return_value_discarded
	connect("button_up", self, "_on_button_up")
# warning-ignore:return_value_discarded
	_timer.connect("timeout", self, "_on_DelayTimer_timeout")

# As soon as the player presses the skip button, start the timer.
func _on_button_down() -> void:
	_timer.start()

# Whenever the timer emits the `timeout` signal, we emit our `timer_ticked` signal, telling the text box to advance dialogues.
func _on_DelayTimer_timeout() -> void:
	emit_signal("timer_ticked")
	
# On release of the button, we stop the timer.
func _on_button_up() -> void:
	_timer.stop()
