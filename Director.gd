extends Node

onready var story := $InkPlayer
onready var _textbox := $TextBox
onready var _character_displayer := $CharacterDisplayer
onready var _background := $Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide the text box initially, so it'll display properly when we need it.
	_textbox.hide()
	# warning-ignore:return_value_discarded
	story.connect("InkContinued", self, "_on_story_continued")
	# warning-ignore:return_value_discarded
	story.connect("InkChoices", self, "_on_choices")
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
			self.call(tag_array[0], tag_array)
		
	# Now we'll display the text in the textbox, wait for the display to finish, then continue to the next line.
	_textbox.show()
	_textbox.display(text, "Sophia") # TODO: pass a character name in here.
	yield(_textbox, "next_requested")
	story.Continue()

func _on_choices(choices) -> void:
	for choice in choices:
		print(choice)

# This is the general idea for iterating through the choices and putting up buttons for them. I'll need to make a ChoiceSelector node and put `onready var _choice_selector := $ChoiceSelector` above first.
#		var choice_index := 0
#		var button := Button.new()
#		button.text = choice
#		choice_index = choices.find(choice,0)
#		_choice_selector.add_child(button)
#		button.connect("pressed", self, "_on_Button_pressed", [choice_index])
#	(_choice_selector.get_child(0) as Button).grab_focus()

#func _on_Button_pressed(target_id) -> void:
#	story.ChooseChoiceIndex(target_id)
#	for child in _choice_selector.get_children():
#		child.queue_free()
#	story.Continue()

func background(arguments) -> void:
	# TODO: Add some input checking and include more possible arguments.
	var bg: Background = ResourceDB.get_background(arguments[1])
	_background.texture = bg.texture
