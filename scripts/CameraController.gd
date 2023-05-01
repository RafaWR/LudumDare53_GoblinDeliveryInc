extends Camera2D
class_name CameraController

@onready var blackout : ColorRect = $Blackout

func fade_in(duration : float) -> void:
	get_tree().create_tween().tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 0.0), duration)

func fade_out(duration : float) -> void:
	get_tree().create_tween().tween_property(blackout, "color", Color(0.0, 0.0, 0.0, 1.0), duration)
