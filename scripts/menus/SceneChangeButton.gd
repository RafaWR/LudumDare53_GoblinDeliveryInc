extends Button

@export var scene_loaded : String

func _pressed() -> void:
	if Globals.scene_manager.is_loading:
		return
	
	SoundSystem.play(Sound.BUTTON)
	Globals.scene_manager.load_scene(scene_loaded)
