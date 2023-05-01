extends Node2D

@export var music_volume_cut : float

@onready var control_nodes : Array = [ $Background, $Resume, $Menu ]

var _opened : bool = true

func _ready() -> void:
	$Resume.pressed.connect(toggle)
	toggle()

func _input(event : InputEvent) -> void:
	if event.is_echo() or not event.is_pressed():
		return
	
	if event.is_action("cancel") and Globals.last_cancel_input_frame != Engine.get_frames_drawn():
		toggle()

func toggle() -> void:
	_opened = !_opened
	visible = _opened
	
	get_parent().process_mode = PROCESS_MODE_DISABLED if _opened else PROCESS_MODE_INHERIT
	
	SoundSystem.music_volume = music_volume_cut if _opened else 1.0
	
	for n in control_nodes:
		n.mouse_filter = Control.MOUSE_FILTER_STOP if _opened else Control.MOUSE_FILTER_IGNORE
