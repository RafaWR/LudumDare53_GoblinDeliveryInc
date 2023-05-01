extends Resource
class_name ItemEffect

enum Type
{
	GOBLIN_TYPE = -1,
	SPEED = 0,
	CARRY_SPACE = 10
}

@export var type : Type
@export var value : float
