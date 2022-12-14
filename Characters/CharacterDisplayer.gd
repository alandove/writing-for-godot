## Display and animate [Character] portraits entering from the left or right. Place this behind a [TextBox].
class_name CharacterDisplayer
extends Node

## Emitted when the characters finish displaying or finish their animation
signal display_finished

## Define a constant to select a valid side to display the characters. It maps to the keys of our _displayed variable below.
const SIDE := {LEFT = "left", RIGHT = "right"}
## Use this color to animate characters fading in and out.
const COLOR_WHITE_TRANSPARENT = Color(1.0, 1.0, 1.0, 0.0)
## Map animation text ids to a function that animates a character sprite
const ANIMATIONS := {"enter": "_tween_enter", "leave": "_tween_leave"}

var _displayed := {left = null, right = null}

onready var _tween: Tween = $Tween
onready var _left_sprite: Sprite = $Left
onready var _right_sprite: Sprite = $Right
# Set default sprite positions based on how they start.
onready var _default_left: Vector2 = _left_sprite.position
onready var _default_right: Vector2 = _right_sprite.position

func _ready() -> void:
	# Hide both sprites to avoid showing portraits at the start.
	_left_sprite.hide()
	_right_sprite.hide()
	# Tween for the animation functions
# warning-ignore:return_value_discarded
	_tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")

func exeunt() -> void:
	_left_sprite.hide()
	_right_sprite.hide()
	
func _on_Tween_tween_all_completed() -> void:
	emit_signal("display_finished")

# Display a character in the left or right position, with optional animation and expression choices.
func display(character: Character, expression := "", animation := "none", side: String = SIDE.LEFT) -> void:
	# Raise an error if we passed an invalid side value.
	assert(side in SIDE.values())
	
	# Figure out whether we're modifying the left or right sprite. Start by picking a node based on the side value passed to us.
	# The right sprite is set to "Flip H" in the node settings, so it'll automatically show up flipped. Use set_flip_h to change that in code.
	var sprite: Sprite = _left_sprite if side == SIDE.LEFT else _right_sprite
	# Next, we see if this character is already displayed, and if so on which side, so we can continue using the corresponding sprite.
	if character == _displayed.left:
		sprite = _left_sprite
	elif character == _displayed.right:
		sprite = _right_sprite
	# If we haven't displayed this character yet, we store the side on which it's showing up.
	else:
		_displayed[side] = character
	
	# Now update the sprite's texture, using the character's expression, and execute an animation if applicable.
	sprite.texture = character.get_image(expression)
	sprite.show()

	if animation != "none":
		# 'call()' calls the function corresponding to the first argument and passes the other arguments to it.
		call(ANIMATIONS[animation], side, sprite)

## Fade in and move the character to the anchor position.
func _tween_enter(from_side: String, sprite: Sprite) -> void:
	# Set default position initially so re-entry doesn't yield a sprite stuck halfway off the screen.
	sprite.position = _default_left if from_side == SIDE.LEFT else _default_right
	var offset := -200 if from_side == SIDE.LEFT else 200
	var start := sprite.position + Vector2(offset, 0.0)
	var end := sprite.position
	
	# Position animation
# warning-ignore:return_value_discarded
	_tween.interpolate_property(
		sprite, "position", start, end, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	# Opacity animation
# warning-ignore:return_value_discarded
	_tween.interpolate_property(
	sprite, "modulate", COLOR_WHITE_TRANSPARENT, Color.white, 0.25
	)
# warning-ignore:return_value_discarded
	_tween.start()
	# Set starting properties manually so we don't get visual glitches if the player is spamming the "Enter" key.
	sprite.position = start
	sprite.modulate = COLOR_WHITE_TRANSPARENT

# Fade out and move the character offstage.
func _tween_leave(from_side: String, sprite: Sprite) -> void:
	var offset := -200 if from_side == SIDE.LEFT else 200
	
	var start := sprite.position
	var end := sprite.position + Vector2(offset, 0.0)
	
	# Position animation
# warning-ignore:return_value_discarded
	_tween.interpolate_property(
	sprite, "position", start, end, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	# Opacity animation
# warning-ignore:return_value_discarded
	_tween.interpolate_property(
		sprite,
		"modulate",
		Color.white,
		COLOR_WHITE_TRANSPARENT,
		0.25,
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT,
		0.25
	)
# warning-ignore:return_value_discarded
	_tween.start()
# warning-ignore:return_value_discarded
	_tween.seek(0.0)
	# Clear the `_displayed` on this side now that the character has left.
	_displayed[from_side] = null

# If the player presses Enter before the character animations end, seek to the end of the animations.
# Disabled for now because keyboard controls bounce through and truncate the animations unintentionally.
#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_accept") and _tween.is_active():
## warning-ignore:return_value_discarded
#		_tween.seek(INF)
