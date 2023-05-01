extends Node2D
class_name GoblinPathBuilder

@export var world_size : Vector2i

var _mouse_position : Vector2i

var _last_path_point : Vector2i
var _confirmed_path : bool
var _edited_path_point : Vector2i
var _has_edited_path_point : bool:
	set(value):
		if _has_edited_path_point == value:
			return
		_has_edited_path_point = value
		
		if _confirmed_path:
			_confirmed_path = false
			_last_path_point = goblin.path.get_last_point()
		elif not _has_edited_path_point:
			goblin.path.remove_last_point()

var goblin : Goblin:
	set(value):
		if goblin == value:
			return
		
		if goblin != null:
			goblin.walk_state_changed.disconnect(_on_walk_state_changed)
			_is_editing = false
			
			if not goblin.is_walking:
				goblin.path.reset(goblin.grid_position)
		
		goblin = value
		
		if goblin != null:
			goblin.walk_state_changed.connect(_on_walk_state_changed)
			_on_walk_state_changed(goblin.is_walking)
			_update_mouse_position()

var _is_editing : bool:
	set(value):
		if _is_editing == value:
			return
		_is_editing = value
		
		if _is_editing:
			_last_path_point = goblin.path.get_last_point()
			_update_path_edit()
		else:
			_has_edited_path_point = false

func _input(event : InputEvent) -> void:
	if event.is_echo() or not event.is_pressed() or not _is_editing:
		return
	
	if event.is_action("interact_1") and _has_edited_path_point:
		_confirmed_path = true
		_has_edited_path_point = false
	elif event.is_action("confirm") and _last_path_point != goblin.grid_position:
		_has_edited_path_point = false
		goblin.is_walking = true

func _update_mouse_position() -> void:
	var mouse_pos : Vector2 = get_global_mouse_position()
	mouse_pos += get_viewport().size / (get_viewport().get_camera_2d().zoom.x * 2.0)
	mouse_pos /= Globals.PPT
	var rounded_pos : Vector2i = Vector2i(floori(mouse_pos.x), floori(mouse_pos.y))
	if rounded_pos != _mouse_position:
		_mouse_position = rounded_pos
		_update_path_edit()

func _update_path_edit() -> void:
	if not _is_editing:
		return
	
	var pos : Vector2i = _last_path_point
	
	if _is_outside_bounds(_mouse_position) or _mouse_position == pos:
		_has_edited_path_point = false
		return
	
	var diff : Vector2i = _mouse_position - pos
	var dist : int = maxi(absi(diff.x), absi(diff.y))
	var angle : float = Vector2(diff).angle()
	var dir : Direction.Values = Direction.from_angle(angle)
	var target : Vector2i = pos + dist * Direction.to_vector(dir)
	
	if _has_edited_path_point && _edited_path_point == target:
		return
	
	if _is_outside_bounds(target):
		_has_edited_path_point = false
		return
	
	_edited_path_point = target
	
	if _has_edited_path_point:
		goblin.path.remove_last_point()
	else:
		_has_edited_path_point = true
	
	goblin.path.add_point(dist, dir)

func _on_walk_state_changed(is_walking : bool) -> void:
	_last_path_point = goblin.path.get_last_point()
	_is_editing = not is_walking

func _process(delta : float) -> void:
	if goblin != null:
		_update_mouse_position()

func _is_outside_bounds(pos : Vector2i) -> bool:
	return pos.x < 0 or pos.y < 0 or pos.x >= world_size.x or pos.y >= world_size.y
