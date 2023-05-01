extends Node

signal inspect(object : Object)

const SQRT2 : float = 1.41421356237

# pixels per tile
const PPT : int = 16

var scene_manager : SceneManager

var last_cancel_input_frame : int

func cancel_processed() -> void:
	last_cancel_input_frame = Engine.get_frames_drawn()
