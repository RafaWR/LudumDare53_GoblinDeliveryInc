extends Node2D
class_name GoblinPath

signal path_updated()
signal finished_path()
signal has_path_changed(has_path : bool)

var _start_position : Vector2i
var _path : Array[PathPoint] = []
var _path_position : float

var selected : bool = false:
	set(value):
		if selected == value:
			return
		selected = value
		
		var add : int = 2 if selected else -2
		for i in range(_path.size()):
			for j in range(_path[i].sprites.size()):
				_path[i].sprites[j].node.frame_coords.y += add

func has_path() -> bool:
	return _path.size() > 0

func get_last_point() -> Vector2i:
	if _path.size() == 0:
		return _start_position
	return _path[_path.size() - 1].position

func get_current_tile() -> Vector2i:
	var point_index : int = floori(_path_position)
	var point : PathPoint = _path[point_index]
	var point_position : float = _path_position - point_index
	var tile_index : int = floori(point_position * point.distance * 2)
	if tile_index > 0:
		tile_index = (tile_index + (tile_index % 2)) / 2
	return point.tiles[tile_index]

func move(speed : float) -> Vector2:
	if not has_path():
		return get_current_tile()
	
	var point_index : int = floori(_path_position)
	var point : PathPoint = _path[point_index]
	
	if Direction.is_diagonal(point.direction):
		speed /= Globals.SQRT2
	
	var moved_dist : float = speed / point.distance
	
	_path_position += moved_dist
	if _path_position >= point_index + 1:
		_path_position = point_index + 1
		
		if point_index == _path.size() - 1:
			reset(get_last_point())
			finished_path.emit()
			return _start_position
	
	var point_position : float = _path_position - point_index
	
	# update sprites
	for i in range(point.sprites.size()):
		if point.sprites[i].path_pos <= point_position:
			point.sprites[i].node.visible = false
	
	var prev_pos : Vector2 = point.tiles[0]
	return prev_pos.lerp(point.position, point_position)

func reset(start_position : Vector2i) -> void:
	_start_position = start_position
	_path_position = 0.0
	
	for i in range(_path.size()):
		for j in range(_path[i].sprites.size()):
			_path[i].sprites[j].node.queue_free()
	_path.clear()
	
	has_path_changed.emit(false)
	path_updated.emit()

func add_point(distance : int, direction : Direction.Values) -> void:
	var prev_pos : Vector2i = _start_position if _path.size() == 0 else _path[_path.size() - 1].position
	var dir_vec : Vector2i = Direction.to_vector(direction)
	
	var point := PathPoint.new()
	_path.append(point)
	
	point.distance = distance
	point.position = prev_pos + distance * dir_vec
	point.direction = direction
	
	var tile : Vector2i = prev_pos
	for i in range(distance + 1):
		point.tiles.append(tile)
		tile += dir_vec
	
	# sprite building
	var diagonal : bool = Direction.is_diagonal(direction)
	var sprite_scenes : Array[PackedScene] = get_direction_array(direction)
	var sprite_signal : int = get_direction_signal(direction)
	
	tile = prev_pos
	for i in range(-1, distance):
		for j in range(-1, 2):
			if (i == -1 and (j == -1 or j == 0)) or (i == distance - 1 and j == 1):
				continue
			
			var scene : PackedScene = POINT if i == distance - 1 and j == 0 else sprite_scenes[1 + j * sprite_signal]
			var node : Sprite2D = scene.instantiate()
			var offset : Vector2 = node.position
			add_child(node)
			node.position = offset + Vector2(tile) * Globals.PPT
			
			if selected:
				node.frame_coords.y += 2
			
			var sprite := PathSprite.new()
			sprite.node = node
			sprite.path_pos = ((i + 1) + j * 0.4) / distance
			
			point.sprites.append(sprite)
		
		tile += dir_vec
	
	if _path.size() == 1:
		has_path_changed.emit(true)
	path_updated.emit()

func remove_last_point() -> void:
	var last : PathPoint = _path[_path.size() - 1]
	
	for i in range(last.sprites.size()):
		last.sprites[i].node.queue_free()
	
	_path.pop_back()
	
	if _path.size() == 0:
		has_path_changed.emit(false)
	path_updated.emit()

class PathPoint:
	var distance : int
	var position : Vector2i
	var direction : Direction.Values
	
	var tiles : Array[Vector2i] = []
	var sprites : Array[PathSprite] = []

class PathSprite:
	var node : Sprite2D
	var path_pos : float

###############################################################
#                       PATH SPRITES                          #
###############################################################

const POINT : PackedScene = preload("res://scenes/path_parts/point.tscn")

const HORIZONTAL : Array[PackedScene] = [
	preload("res://scenes/path_parts/h_left.tscn"),
	preload("res://scenes/path_parts/h_mid.tscn"),
	preload("res://scenes/path_parts/h_right.tscn")
	]

const VERTICAL : Array[PackedScene] = [
	preload("res://scenes/path_parts/v_up.tscn"),
	preload("res://scenes/path_parts/v_mid.tscn"),
	preload("res://scenes/path_parts/v_down.tscn")
	]

const UP_RIGHT : Array[PackedScene] = [
	preload("res://scenes/path_parts/ur_left.tscn"),
	preload("res://scenes/path_parts/ur_mid.tscn"),
	preload("res://scenes/path_parts/ur_right.tscn")
	]

const DOWN_RIGHT : Array[PackedScene] = [
	preload("res://scenes/path_parts/dr_left.tscn"),
	preload("res://scenes/path_parts/dr_mid.tscn"),
	preload("res://scenes/path_parts/dr_right.tscn")
	]

func get_direction_array(direction : Direction.Values) -> Array[PackedScene]:
	match direction:
		Direction.UP:
			return VERTICAL
		Direction.DOWN:
			return VERTICAL
		Direction.LEFT:
			return HORIZONTAL
		Direction.RIGHT:
			return HORIZONTAL
		Direction.UP_LEFT:
			return DOWN_RIGHT
		Direction.UP_RIGHT:
			return UP_RIGHT
		Direction.DOWN_LEFT:
			return UP_RIGHT
		Direction.DOWN_RIGHT:
			return DOWN_RIGHT
	return []

func get_direction_signal(direction : Direction.Values) -> int:
	if direction == Direction.UP or direction == Direction.LEFT or direction == Direction.UP_LEFT or direction == Direction.DOWN_LEFT:
		return -1
	return 1
