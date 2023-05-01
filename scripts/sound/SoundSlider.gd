extends VSlider

@onready var fill : Sprite2D = $Fill

func _ready() -> void:
	value = SoundSystem.volume

func _value_changed(new_value : float) -> void:
	SoundSystem.volume = new_value
	fill.scale.y = new_value
