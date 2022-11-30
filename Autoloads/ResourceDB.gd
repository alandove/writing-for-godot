## Auto-loaded node that loads and gives access to all [Background] and [Character] resources in the game.
## Loaded resources end up in a dictionary with the form `{ resource_id: resource_object }`, so we can access any resource through its unique identifier.

extends Node

# We're loading all of the resources for the whole game into memory here. If the game gets huge, we might have to rework this to load only the resources for, say, each chapter.
onready var _characters := _load_resources("res://Characters/", "_is_character")
onready var _backgrounds := _load_resources("res://Backgrounds", "_is_background")
onready var _sounds := _load_resources("res://Sounds", "_is_sound")

# Identifier for the default "Narrator" character resource.
const NARRATOR_ID := "narrator"

func get_narrator() -> Character:
	return _characters.get(NARRATOR_ID)

## Finds and loads resources of a given type in `directory_path`. We pass the name of a function to do type checks, and we call that function on each loaded resource with `call()`.
func _load_resources(directory_path: String, check_type_function: String) -> Dictionary:
	var directory := Directory.new()
	if directory.open(directory_path) != OK:
		return {}
	
	var resources := {}
	
# warning-ignore:return_value_discarded
	directory.list_dir_begin()
	var filename = directory.get_next()
	while filename != "":
		# Loop over one directory - we don't explore subdirectories.
		if filename.ends_with(".tres"):
			# `String.plus_file()` concatenates paths following Godot's virtual filesystem.
			var resource: Resource = load(directory_path.plus_file(filename))
			
			# Now we check the resource's type. If it doesn't match what we expect, we skip it. Resources are reference-counted, so as the local variable `resource` clears, Godot frees the object from memory.
			if not call(check_type_function, resource):
				continue
			
			# If the resource passes the type check, store it.
			resources[resource.id] = resource
		filename = directory.get_next()
	directory.list_dir_end()
	
	return resources

# Type checking functions
func _is_character(resource: Resource) -> bool:
	return resource is Character

func _is_background(resource: Resource) -> bool:
	return resource is Background

func _is_sound(resource: Resource) -> bool:
	return resource is Sound

# The database allows you to get a resource of a given type. These functions provide the interface.
func get_character(character_id: String) -> Character:
	return _characters.get(character_id)
	
func get_background(background_id: String) -> Background:
	return _backgrounds.get(background_id)

func get_sound(sound_id: String) -> Sound:
	return _sounds.get(sound_id)

