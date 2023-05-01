extends Hoverable

@export var inspected : Node

func _input(input : InputEvent) -> void:
	if input.is_echo() or not input.is_pressed() or not is_hovered:
		return
	
	if input.is_action("interact_1"):
		Globals.inspect.emit(inspected)
