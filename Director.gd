extends Node

onready var story := $InkPlayer
onready var _textbox := $TextBox
onready var _character_displayer := $CharacterDisplayer
onready var _background := $Background

var timer := Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide the text box initially, so it'll display properly when we need it.
	_textbox.hide()
	# warning-ignore:return_value_discarded
	story.connect("InkContinued", self, "_on_story_continued")
	# warning-ignore:return_value_discarded
	story.connect("InkChoices", self, "_on_choices")

# The timer paces the display of text, and keeps signals from stepping on each other.
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 0.1
# warning-ignore:return_value_discarded
	timer.connect("timeout", story, "Continue")
	timer.start()

func _on_story_continued(text, tags) -> void:
	print(tags)
	# TODO: The tag parser is here right now, but it probably belongs in a separate function, or maybe even a separate script.
	# Idea: "# function_name argument_1 argument_2 etc" in the Ink file gets parsed against a list of functions. Then just split the space-delimited tags and call(function_name(arguments: Array).
	for tag in tags:
		var tag_array = tag.split(" ", true, 0)
		if "background" in tag_array:
			# TODO: this needs a more robust solution
			var bg: Background = ResourceDB.get_background(tag_array[1])
			_background.texture = bg.texture
			
	# TODO: We'll also need to figure out how to get individual lines to display one at a time. Ink seems to feed them one at a time, but they rush past.
	# Experimenting with splitting the lines into an array, but each array only has one line.
	var text_array = text.split("\n", true, 0)
	print(text_array)
	_textbox.show()
	_textbox.display(text, "Sophia")
	yield(_textbox, "next_requested")

func _on_choices(choices) -> void:
	for choice in choices:
		print(choice)
		#story.ChooseChoiceIndex(0)	
