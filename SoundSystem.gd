## Subsystem for handling music and sound effects.
extends Node

onready var _tween: Tween = $Tween
var _music_volume := 0.0
var _fx_volume := 0.0

func set_music_volume(volume) -> void:
	_music_volume = volume

func set_fx_volume(volume) -> void:
	_fx_volume = volume

func play(arguments) -> void:
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
		audio_player.volume_db = _music_volume
	audio_player.play()

func play_music(track) -> void:
	pass

func play_fx(sound) -> void:
	pass

func _audio_player_finished(audio_player_ref) -> void:
	audio_player_ref.queue_free()
	
