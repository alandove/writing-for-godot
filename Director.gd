extends Node

onready var story := $InkPlayer
var timer := Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

func _on_story_continued(text, tag_array) -> void:
	print(text)
	print(tag_array)

func _on_choices(choices) -> void:
	for choice in choices:
		print(choice)
		#story.ChooseChoiceIndex(0)
	
