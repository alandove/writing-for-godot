extends Node

onready var story := $InkPlayer
onready var _textbox := $TextBox
onready var _character_displayer := $CharacterDisplayer
onready var _background := $Background

var timer := Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	if tags:
		for tag in tags:
			var tag_array = tag.split(" ", true, 0)
			if "background" in tag_array:
				var bg: Background = ResourceDB.get_background(tag_array[1])
				_background.texture = bg.texture
	if text != "":
		_textbox.show()
		_textbox.display(text, "Sophia", 10)
		yield(_textbox, "next_requested")

	print(text)
	print(tags)

func _on_choices(choices) -> void:
	for choice in choices:
		print(choice)
		#story.ChooseChoiceIndex(0)	
