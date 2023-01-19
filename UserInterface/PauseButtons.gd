extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pause_option(target_id)

# TODO: This should be based on the design of ChoiceSelector: when the player hits Esc or clicks "Pause," we'll have the `Director` make the `PauseMenu` scene appear. Then we need to tell `PauseButtons` to generate the options as buttons, and send a signal up when the player picks one. Once the `Director` gets that signal, it processes it and hides the `PauseMenu` again.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
