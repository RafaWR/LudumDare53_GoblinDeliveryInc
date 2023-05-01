extends Sprite2D
class_name ItemDisplay

var _item : Item

func display(item : Item) -> void:
	_item = item
	
	visible = item != null
	
	if item != null:
		texture = item.sprite
	
	inspection_updated.emit()

signal inspection_updated()
func inspect() -> String:
	if _item == null:
		return ""
	return _item.inspect()
