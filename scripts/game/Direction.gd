extends Node
class_name Direction

enum Values
{
	UP,
	DOWN,
	LEFT,
	RIGHT,
	
	UP_LEFT,
	UP_RIGHT,
	DOWN_LEFT,
	DOWN_RIGHT
}

const UP := Values.UP
const DOWN := Values.DOWN
const LEFT := Values.LEFT
const RIGHT := Values.RIGHT
const UP_LEFT := Values.UP_LEFT
const UP_RIGHT := Values.UP_RIGHT
const DOWN_LEFT := Values.DOWN_LEFT
const DOWN_RIGHT := Values.DOWN_RIGHT

static func to_vector(value : Values) -> Vector2i:
	match value:
		UP:
			return Vector2i(0, -1)
		DOWN:
			return Vector2i(0, 1)
		LEFT:
			return Vector2i(-1, 0)
		RIGHT:
			return Vector2i(1, 0)
		UP_LEFT:
			return Vector2i(-1, -1)
		UP_RIGHT:
			return Vector2i(1, -1)
		DOWN_LEFT:
			return Vector2i(-1, 1)
		DOWN_RIGHT:
			return Vector2i(1, 1)
	return Vector2i.ZERO

static func from_vector(vector : Vector2i) -> Direction.Values:
	match vector:
		Vector2i(0, -1):
			return UP
		Vector2i(0, 1):
			return DOWN
		Vector2i(-1, 0):
			return LEFT
		Vector2i(1, 0):
			return RIGHT
		Vector2i(-1, -1):
			return UP_LEFT
		Vector2i(1, -1):
			return UP_RIGHT
		Vector2i(-1, 1):
			return DOWN_LEFT
		Vector2i(1, 1):
			return DOWN_RIGHT
	return UP

static func is_diagonal(value : Values) -> bool:
	return value == UP_LEFT or value == UP_RIGHT or value == DOWN_LEFT or value == DOWN_RIGHT

static func from_angle(angle : float) -> Direction.Values:
	var vec := Vector2.from_angle(angle)
	var rounded := Vector2i(roundi(vec.x), roundi(vec.y))
	return from_vector(rounded)
