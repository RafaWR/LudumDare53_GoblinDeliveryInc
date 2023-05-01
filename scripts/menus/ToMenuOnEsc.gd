extends Node

func _input(event : InputEvent) -> void:
	if event.is_echo() or not event.is_pressed():
		return
	
	if event.is_action("cancel"):
		Globals.scene_manager.load_scene("title_screen")
