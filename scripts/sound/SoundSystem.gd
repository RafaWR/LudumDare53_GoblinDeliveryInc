extends Node

var volume : float = 1.0:
	set(value):
		volume = value
		AudioServer.set_bus_volume_db(0, linear_to_db(volume))

var music_volume : float:
	set(value):
		music_volume = value
		AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))

func play(sound : String) -> void:
	get_node(sound).playing = true
