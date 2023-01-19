class_name Director
extends Node

onready var story := $InkPlayer
onready var _textbox := $TextBox
onready var _character_displayer := $CharacterDisplayer
onready var _background := $Background
onready var _anim_player: AnimationPlayer = $FadeAnimationPlayer
onready var _sound_system := $SoundSystem
# Button bar for the main game controls.
onready var _button_bar : HBoxContainer = $TextBox/ButtonBar
# Pop-up dialog to confirm when a player wants to exit to the main screen.
onready var _pause_menu : TextureRect = $PauseMenu

# TODO: Move the save and load functions up to Main, and signal for them from Director.
#onready var _save_button : Button = $TextBox/SaveButton
#onready var _load_button : Button = $TextBox/LoadButton

# Load variables from the Ink file.
onready var characters: String = story.GetVariable("characters")
var character_name: String

## Emitted when a transition, such as a fade in or fade out of the whole scene, ends. This lets the node wait for its animations to finish before triggering other events.
signal transition_finished

# Emitted when the player requests an exit, save, or load.
signal exit_requested

func _ready() -> void:
	# warning-ignore:return_value_discarded
	story.connect("InkContinued", self, "_on_story_continued")
	# warning-ignore:return_value_discarded
	story.connect("InkChoices", self, "_on_choices")
# warning-ignore:return_value_discarded
	story.connect("InkEnded", self, "_on_end")
# warning-ignore:return_value_discarded
	_button_bar.connect("option_chosen", self, "_on_option_chosen")
# warning-ignore:return_value_discarded
#	_pause_menu.connect("confirmed", self, "_on_exit_confirmed")
#	_pause_menu.get_cancel().connect("pressed", self, "_on_exit_cancelled")
	
	# TODO: Move save and load functions up to Main, and signal for them from Director.
# warning-ignore:return_value_discarded
#	_save_button.connect("button_down", self, "_save_requested")
# warning-ignore:return_value_discarded
#	_load_button.connect("button_down", self, "_load_requested")
	# Start with visible parts hidden, so the title screen can come up.
	_textbox.hide()
	_background.hide()
	_pause_menu.hide()
	
func start_story() -> void:
	# Show the initial background - the textbox will show up on its own.
	_background.show()
	_character_displayer.show()
	_button_bar.show()
	# Start the story.
	story.Continue()

func stop_story() -> void:
	_background.hide()
	_textbox.hide()
	_character_displayer.hide()
	_button_bar.hide()
	
func load_game() -> void:
	# TODO: Build a function that reads the Ink state from a file, sets up the appropriate knot and and characters, then calls `start_story`. Or move the save and load functions up to Main and signal for them from Director.
	pass

# Previous save and load functions.
#func _save_requested() -> void:
#	var file = File.new()
#	file.open("save.json", File.WRITE)
#	story.SaveStateOnDisk("user://save.json")
#	file.close()

#func _load_requested() -> void:
#	var file = File.new()
#	file.open("save.json", File.READ)
#	story.LoadStateFromDisk("user://save.json")
#	file.close()


func _on_option_chosen(option) -> void:
	if option == "exit":
		_pause_menu.show()
#		_pause_menu.grab_focus()
		get_tree().paused = true
		# TODO: Fix this so keyboard controls go to the `ExitConfirmation`.

func _on_exit_cancelled() -> void:
	_pause_menu.release_focus()
	_pause_menu.hide()
	get_tree().paused = false
	
func _on_exit_confirmed() -> void:
	emit_signal("exit_requested", "exit")
	
func _on_story_continued(text, tags) -> void:
#	_load_requested()
#	print("The loaded story state in JSON format is ", story.GetState())

	print(text)
	print(tags)
	# The tag parsing system is all in here currently.
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
		# If the tag matches a character name, set it to display in the name box, and if there's a second tag with it, process that as an expression change.
		elif characters.find(tag_array[0]) != -1:
			character_name = tag_array[0]
			if tag_array.size() > 1:
				var show_arguments: Array = ["show", character_name.to_lower(), tag_array[1], "none", "left"]
				show(show_arguments)
			
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

func _on_end() -> void:
	get_tree().quit()

# =====Begin functions intended to be called from the Ink file.=====

# Fade functions and `yield` will play animations in sequence.
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
	
	# TODO: Add some code here to store the new character information in the Ink file, so we can reload everyone properly from a save file. I may need to create a dictionary of the characters currently being shown on screen, and store that variable in the Ink.
	
	# Now let's put it all together and ship it out to the CharacterDisplayer.
	_character_displayer.display(character, expression, animation, side)

func audio(arguments) -> void:
	# The audio tag should be in the format "audio, type, track." We'll set the current volume, then call `SoundSystem`'s `play_audio` function and send it the track and type as arguments.
	_sound_system.set_music_volume(story.GetVariable("music_volume"))
	_sound_system.set_fx_volume(story.GetVariable("fx_volume"))
	var track = arguments[2]
	var type = arguments[1]
	_sound_system.play_audio(track, type)
