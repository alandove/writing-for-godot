extends Node

onready var story := $InkPlayer
onready var _textbox := $TextBox
onready var _character_displayer := $CharacterDisplayer
onready var _background := $Background
onready var _anim_player: AnimationPlayer = $FadeAnimationPlayer
onready var _tween: Tween = $Tween
onready var characters: String = story.GetVariable("characters")
var character_name: String

## Emitted when a transition, such as a fade in or fade out of the whole scene, ends. This lets the node wait for its animations to finish before triggering other events.
signal transition_finished

func _ready() -> void:
	# warning-ignore:return_value_discarded
	story.connect("InkContinued", self, "_on_story_continued")
	# warning-ignore:return_value_discarded
	story.connect("InkChoices", self, "_on_choices")
	# Start the story
	story.Continue()

func _on_story_continued(text, tags) -> void:
	print(tags)
	# TODO: The tag parsing system is all in here right now, but the functions it calls probably belong in a separate script.
	# Strategy: "# function_name argument_1 argument_2 etc" in the Ink file gets parsed into the function name and arguments, then we call(function_name(arguments: Array).
	
	# First, we split each tag into its space-delimited elements.
	for tag in tags:
		var tag_array = tag.split(" ", true, 0)
		# If the first element in the resulting array matches a function in this script, we call that function and send the array as an argument.
		if self.has_method(tag_array[0]):
			print("Now executing ", tag_array[0])
			self.call(tag_array[0], tag_array)
			# To get fade_out followed by fade_in to work.
			if _anim_player.is_playing():
				yield(self, "transition_finished")
			if tag_array[0] == "show" and tag_array[3] != "none":
				yield(_character_displayer, "display_finished")
		# If the tag matches a character name, set it to display in the name box.
		elif characters.find(tag_array[0]) != -1:
			character_name = tag_array[0]

	if _anim_player.is_playing():
		yield(self, "transition_finished")
	# Now we'll display the text in the textbox, wait for the display to finish, then continue to the next line.
	_textbox.show()
	_textbox.display(text, character_name)
	yield(_textbox, "next_requested")
	story.Continue()

func _on_choices(choices) -> void:
	yield(_textbox, "next_requested")
	# Display choices in the TextBox, wait for user input, and continue the story based on that.
	_textbox.display_choices(choices)
	var chosen = yield(_textbox, "choice_made")
	story.ChooseChoiceIndexAndContinue(chosen)

# Functions and `yield` will play animations in sequence.
func fade_in(_args) -> void:
	_anim_player.play("fade_in")
	yield(_anim_player, "animation_finished")
	yield(_textbox.fade_in_async(), "completed")
	emit_signal("transition_finished")

func fade_out(_args) -> void:
	_anim_player.play("fade_out")
	yield(_textbox.fade_out_async(), "completed")
	yield(_anim_player, "animation_finished")
	_character_displayer.exeunt()
	emit_signal("transition_finished")

func background(arguments) -> void:
	# TODO: Add some input checking and include more possible arguments.
	var bg: Background = ResourceDB.get_background(arguments[1])
	if bg:
		_background.texture = bg.texture

func show(arguments) -> void:
	# We're expecting four arguments every time, in order: character, expression, animation, side.
	var character: Character = (
		ResourceDB.get_character(arguments[1])
	)
	# If the ResourceDB couldn't find that character name, don't try to show them.
	if !character:
		return
	
	var expression: String = arguments[2]
	var animation: String = arguments[3]
	var side: String = arguments[4]
	
	# Now let's put it all together and ship it out to the CharacterDisplayer.
	_character_displayer.display(character, expression, animation, side)

func audio(arguments) -> void:
	# Create an AudioStreamPlayer, add it to the scene tree, then set the stream and play it.
	# Because we're generating these in code, we can add more AudioStreamPlayers that will play simultaneously.
	# TODO: Add an option to sequence sound effects, so fx called in rapid succession don't all play at once (or can, if that's the intent).
	var volume := -12.0
	var sound: Sound = ResourceDB.get_sound(arguments[2])
	if !sound:
		print("Sound not found.")
		return
	var audio_player = AudioStreamPlayer.new()
	# Set the audio player's name the same as the sound's `id`, so we can keep track of it.
	audio_player.name = sound.id
	# Set the volume. 
	# TODO: enable setting this with tags in the Ink.
	audio_player.volume_db = volume
	# Connect the `finished` signal to a function to free the node, passing the audio player reference to it to free the right one.
	audio_player.connect("finished", self, "_audio_player_finished", [audio_player])
	add_child(audio_player)
	audio_player.stream = sound.stream
	# If we're playing music, fade and stop any that's currently playing, then put the new player into the `music` group, so we can keep from playing two tracks simultaneously.
	if arguments[1] == "music":
		var music_player = get_tree().get_nodes_in_group("music")
		if music_player:
# warning-ignore:return_value_discarded
			_tween.interpolate_property(
				music_player[0],
				"volume_db",
				volume,
				-30.0,
				1.0,
				Tween.TRANS_QUAD,
				Tween.EASE_IN
			)
# warning-ignore:return_value_discarded
			_tween.start()
			yield(_tween, "tween_all_completed")
			music_player[0].stop()
		audio_player.add_to_group("music")
	audio_player.play()

func _audio_player_finished(audio_player_ref) -> void:
	audio_player_ref.queue_free()
	
