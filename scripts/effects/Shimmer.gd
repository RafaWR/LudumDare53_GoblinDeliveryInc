extends Sprite2D

@export var shimmer_delay_range : Vector2

var _shimmer_timer : float

func shimmer() -> void:
	offset = Vector2(randf_range(-2.0, 2.0), randf_range(-2.0, 2.0))
	frame = 0
	
	get_tree().create_tween().tween_property(self, "frame", 4, 0.8)
	get_tree().create_tween().tween_property(self, "offset", Vector2(randf_range(-6.0, 6.0), randf_range(-6.0, 8.0)), 0.8)

func _process(delta : float) -> void:
	if not visible:
		return
	
	_shimmer_timer -= delta
	if _shimmer_timer <= 0.0:
		shimmer()
		_shimmer_timer = randf_range(shimmer_delay_range.x, shimmer_delay_range.y)
