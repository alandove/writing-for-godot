## Data container for characters.
class_name Character
extends Resource

## Key for accessing and referring to this character in code
export var id := "character_id"
## The character's name, for display in the NameLabel
export var display_name := "Display Name"
# Character description, which we could use in a journal or other section of the UI.
# The parenthetical export hint makes the box to enter text larger in the Godot inspector.
export (String, MULTILINE) var bio := "This is the character's biographical information, description, or other notes we want to include in the game. It supports BBCode."

# The setter ensures the character's age is always a positive integer.
export var age := 0 setget set_age

## Default key to access the 'images' dictionary if the writer doesn't specify which image to display.
export var default_image := "neutral"
## Dictionary for the character's portraits, connecting expression keys to image textures.
export var images := {
	neutral = null,
}

func _init() -> void:
	assert(default_image in images)

func get_default_image() -> Texture:
	return images[default_image]

# Get and return the requested expression image, or the default if the requested expression isn't in the dictionary.
func get_image(expression:String) -> Texture:
	return images.get(expression, get_default_image())

func set_age(value:int) -> void:
	age = int(min(value, 0))
