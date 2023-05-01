extends Sprite2D
class_name QuestItemDisplay

@onready var base : Sprite2D = $Base
@onready var stamp : Sprite2D = $Stamp

var _item : QuestItem

func _ready() -> void:
	display(null)

func _exit_tree() -> void:
	_item = null
	inspection_updated.emit()

func display(item : QuestItem) -> void:
	_item = item
	
	visible = item != null
	
	if item != null:
		frame_coords.x = item.size
		base.frame_coords.y = item.size
		stamp.frame_coords.y = item.size
		
		base.frame_coords.x = item.base_sprite
		stamp.frame_coords.x = item.stamp_sprite
	
	inspection_updated.emit()

signal inspection_updated()
func inspect() -> String:
	if _item == null:
		return ""
	return _item.inspect()

func get_inspected_target() -> Vector2i:
	if _item != null:
		return _item.to
	return Vector2i(-10, -10)
