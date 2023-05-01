extends Area2D
class_name Hoverable

signal hovered(hovered : bool)

var is_hovered : bool

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	is_hovered = true
	hovered.emit(true)

func _on_mouse_exited() -> void:
	is_hovered = false
	hovered.emit(false)
