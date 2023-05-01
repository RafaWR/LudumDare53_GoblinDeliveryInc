extends Label
class_name Inspector

@onready var target : Sprite2D = $Transform/Target

var _last_inspected_frame : int
var _inspected : Object

func _ready() -> void:
	Globals.inspect.connect(inspect)
	text = ""

func _input(event : InputEvent) -> void:
	if event.is_echo() or not event.is_pressed() or _last_inspected_frame == Engine.get_frames_drawn():
		return
	
	if event.is_action("interact_2"):
		inspect(null)
	elif event.is_action("cancel") and _inspected != null:
		inspect(null)
		Globals.cancel_processed()

func inspect(object : Object) -> void:
	if _inspected != null and _inspected.has_signal("inspection_updated"):
		_inspected.inspection_updated.disconnect(update_inspect)
	
	text = ""
	_inspected = object
	
	_last_inspected_frame = Engine.get_frames_drawn()
	
	if object == null:
		target.visible = false
	else:
		update_inspect()
		if object.has_signal("inspection_updated"):
			object.inspection_updated.connect(update_inspect)
		
		SoundSystem.play(Sound.SELECT)

func update_inspect() -> void:
	text = _inspected.inspect()
	if _inspected.has_method("get_inspected_target"):
		target.visible = true
		target.position = _inspected.get_inspected_target() * Globals.PPT
	else:
		target.visible = false
