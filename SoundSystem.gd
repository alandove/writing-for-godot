## Subsystem for handling music and sound effects.
extends Node

onready var _tween: Tween = $Tween
var _music_volume := 0.0
var _fx_volume := 0.0

func set_music_volume(volume) -> void:
	_music_volume = volume

func set_fx_volume(volume) -> void:
	_fx_volume = volume

func play_audio(track, type) -> void:
	# Figure out whether we're already playing audio of the given type, and respond appropriately.
	var audio_playing = get_tree().get_nodes_in_group(type)
	var volume = 0.0
	if audio_playing:
		match type:
			"music":
				# If music is playing, fade out and stop the current track before starting a new one.
# warning-ignore:return_value_discarded
				_tween.interpolate_property(
					audio_playing[0],
					"volume_db",
					audio_playing[0].volume_db,
					-30.0,
					1.0,
					Tween.TRANS_QUAD,
					Tween.EASE_IN
				)
# warning-ignore:return_value_discarded
				_tween.start()
				yield(_tween, "tween_all_completed")
				audio_playing[0].stop()
				volume = _music_volume
			"fx":
				# If a sound effect is playing, wait for it to finish before playing the next one.
				yield(audio_playing[0], "finished")
				volume = _fx_volume
		
	# Load the new sound into a new `AudioStreamPlayer`, set volume, add it to the appropriate group, and fire it up.
	var sound: Sound = ResourceDB.get_sound(track)
	if !sound:
		print("Sound not found.")
		return
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = sound.stream
	audio_player.volume_db = volume
	audio_player.connect("finished", self, "_audio_player_finished", [audio_player])
	add_child(audio_player)
	audio_player.add_to_group(type)
	# If we're starting a music track, fade it in.
	if type == "music":
		audio_player.volume_db = (volume -30.0)
		audio_player.play()
		_tween.interpolate_property(
			audio_player,
			"volume_db",
			-30.0,
			volume,
			1.0,
			Tween.TRANS_QUAD,
			Tween.EASE_IN
		)
		_tween.start()
	else:
		audio_player.play()

# Whenever a music or fx `AudioStreamPlayer` finishes, free it from the tree.
func _audio_player_finished(audio_player_ref) -> void:
	audio_player_ref.queue_free()
	
