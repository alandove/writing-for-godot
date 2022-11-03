## Display character lines in a dialogue, with animated text and player input processing.

extends Control

## Emitted when the next line is requested, either by the player or because the current line has been on screen long enough.
## The Director will catch this signal and use it to step to the next line, animation, or other event.
signal next_requested
signal display_finished
signal choice_made(target_id)

## Speed of the text display
export var display_speed := 20.0

## Controls BBCode text of the rich text label child node, using a setter.
export var bbcode_text := "" setget set_bbcode_text

# References to the nodes that will display text and handle player input.
onready var _choice_selector: ChoiceSelector = $ChoiceSelector
onready var _text_label: RichTextLabel = $TextLabel
onready var _name_label: Label = $NameBackground/NameLabel
onready var _name_background: TextureRect = $NameBackground
onready var _blinking_arrow: Control = $TextLabel/BlinkingArrow
onready var _tween: Tween = $Tween
onready var _anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	_blinking_arrow.hide()
	_name_label.text = ""
	_text_label.bbcode_text = ""
	_text_label.visible_characters = 0

	# We use a Tween to animate text display and report when it's done.
# warning-ignore:return_value_discarded
	_tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")
	
	## The text box forwards the `choice_made` signal to the Director via a signal.
# warning-ignore:return_value_discarded
	_choice_selector.connect("choice_made", self, "_on_ChoiceSelector_choice_made")

# The works, but keeps reading the left mouse button every frame until it's released, so all text until the next choice flashes past.
#func _process(_delta: float) -> void:
#	if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
#		if _blinking_arrow.visible:
#			emit_signal("next_requested")
#		else:
#			_tween.seek(INF)

# The choices are a child of the text box, so we have to hide nodes manually. The Director can call this method to display choices.
func display_choices(choices:Array) -> void:
	_name_background.hide()
	_text_label.hide()
	_blinking_arrow.hide()
	
	_choice_selector.display(choices)

# When the player makes a choice, we forward the signal to the Director so it can respond accordingly, and we reset visibility.
func _on_ChoiceSelector_choice_made(target_id) -> void:
	emit_signal("choice_made", target_id)
	_name_background.show()
	_text_label.show()

func display(text: String, character_name :="", speed := display_speed) -> void:
	set_bbcode_text(text)
	
	if speed != display_speed:
		display_speed = speed
	
	if character_name != "":
		_name_label.text = character_name

# Update the TextLabel's text and hide the arrow. We use arrow visibility to encode player input.
func set_bbcode_text(text:String) -> void:
	bbcode_text = text
	if not is_inside_tree():
		yield(self, "ready")
	
	_blinking_arrow.hide()
	_text_label.bbcode_text = bbcode_text
	
	# Defer the call so TextLabel has time to calculate its character count.
	call_deferred("_begin_dialogue_display")

# Calculate the duration of the text animation that will show characters one by one based on the desired display speed.
func _begin_dialogue_display() -> void:
	var character_count := _text_label.get_total_character_count()
# warning-ignore:return_value_discarded
	_tween.interpolate_property(_text_label, "visible_characters", 0, character_count, character_count / display_speed)
# warning-ignore:return_value_discarded
	_tween.start()

func _on_Tween_tween_all_completed() -> void:
	emit_signal("display_finished")
	# Once all the text is visible, show the arrow to indicate we can move to the next line.
	_blinking_arrow.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if _blinking_arrow.visible:
			emit_signal("next_requested")
		else:
			# When the player presses Enter while text is animating, jump to the end of the animation and display the blinking arrow.
			# To do this, we seek the end of the Tween (INFinity).
# warning-ignore:return_value_discarded
			_tween.seek(INF)

# Fade animations for the text box, set up as coroutines with yield().
func fade_in_async() -> void:
	_anim_player.play("fade_in")
	# Reset the fade-in to avoid a visual glitch from sudden appearance and then disappearance of nodes about to fade in.
	_anim_player.seek(0.0, true)
	yield(_anim_player, "animation_finished")

func fade_out_async() -> void:
	_anim_player.play("fade_out")
	yield(_anim_player, "animation_finished")
