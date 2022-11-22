## Uses a Tween object to animate any control node fading in and out. 
extends Control

const COLOR_WHITE_TRANSPARENT := Color(1.0,1.0,1.0,0.0)

## Duration of the fade-in animation in seconds. The disappear animation is half that length.
export var appear_duration := 0.3

# Create a Tween node.
var _tween := Tween.new()

func _ready() -> void:
	# Add the tween to the scene tree so we can use it.
	add_child(_tween)
	# Make the node transparent by default
	modulate = COLOR_WHITE_TRANSPARENT
	
# Fade in the control.
func appear() -> void:
# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate", COLOR_WHITE_TRANSPARENT, Color.white, appear_duration)
# warning-ignore:return_value_discarded
	_tween.start()
	# Force the animation to update instantly to avoid potential visual artifacts.
# warning-ignore:return_value_discarded
	_tween.seek(0)
	
# Fade out the control
func disappear() -> void:
# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate", Color.white, COLOR_WHITE_TRANSPARENT, appear_duration / 2.0)
# warning-ignore:return_value_discarded
	_tween.start()
# warning-ignore:return_value_discarded
	_tween.seek(0)
