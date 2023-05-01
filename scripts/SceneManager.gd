extends Node
class_name SceneManager

@export var fade_duration : float

@export var start_scene : String

@export var scenes : Array[PackedScene] = []

@onready var camera : CameraController = $Camera

var scene_indices : Dictionary = {}

var is_loading : bool

var _current : Node

func _ready() -> void:
	Globals.scene_manager = self
	
	for i in range(scenes.size()):
		var path : String = scenes[i].resource_path
		path = path.trim_suffix(".tscn")
		path = path.trim_prefix("res://scenes/main/")
		scene_indices[path] = i
	
	load_scene(start_scene)

func load_scene(scene : String) -> void:
	if _current != null:
		camera.fade_out(fade_duration)
		await get_tree().create_timer(fade_duration).timeout
		
		_current.queue_free()
	
	_current = scenes[scene_indices[scene]].instantiate()
	add_child(_current)
	
	camera.fade_in(fade_duration)
