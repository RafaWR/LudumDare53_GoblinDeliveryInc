extends Resource
class_name Item

enum Type
{
	BOOT,
	BAG,
	GOBLIN
}

@export var type : Type
@export var price_range : Vector2i
@export var sprite : Texture2D

@export var display_name : String
@export_multiline var description : String

@export var effects : Array[ItemEffect]

func get_effect(type : ItemEffect.Type) -> float:
	for e in effects:
		if e.type == type:
			return e.value
	return 0.0

func inspect() -> String:
	return display_name + "\n" + description
