extends Node
class_name GoblinDisplay

@export var quest_manager : POIManager

@onready var emptygoblin_icon : Sprite2D = $EmptyGoblin
@onready var goblin_icon : Sprite2D = $Goblin
@onready var play_pause : Sprite2D = $PlayPause
@onready var play_pause_button : Hoverable = $PlayPause/Button
@onready var name_display : LineEdit = $Name

@onready var goblin_quest_display : GoblinQuestsDisplay = $Quests
@onready var goblin_item_display : GoblinItemsDisplay = $Items
@onready var poi_display : POIDisplay = $POIDisplay

var goblin : Goblin:
	set(value):
		if goblin == value:
			return
		
		if goblin != null:
			goblin.walk_state_changed.disconnect(_on_walk_state_changed)
			goblin.path.has_path_changed.disconnect(_on_has_path_changed)
		
		goblin = value
		goblin_quest_display.goblin = value
		goblin_item_display.goblin = value
		
		emptygoblin_icon.visible = goblin == null
		goblin_icon.visible = goblin != null
		play_pause.visible = goblin != null
		name_display.visible = goblin != null
		poi_display.poi = null
		
		if goblin == null:
			name_display.deselect()
		else:
			goblin_icon.frame_coords.x = goblin.sprite.frame_coords.x
			name_display.text = goblin.display_name
			
			goblin.walk_state_changed.connect(_on_walk_state_changed)
			goblin.path.has_path_changed.connect(_on_has_path_changed)
			_update_play_pause()
			_update_poi()

func _ready() -> void:
	name_display.text_changed.connect(_on_name_display_changed)

func _input(event : InputEvent) -> void:
	if event.is_echo() or not event.is_pressed():
		return
	
	if event.is_action("interact_1") and play_pause_button.is_hovered:
		goblin.is_walking = not goblin.is_walking
	elif event.is_action("confirm") and goblin != null:
		name_display.visible = false
		name_display.visible = true
	
	poi_display.receive_input(event)

func _update_play_pause() -> void:
	if goblin.is_walking:
		play_pause.visible = true
		play_pause.frame = 0
	elif goblin.path.has_path():
		play_pause.visible = true
		play_pause.frame = 1
	else:
		play_pause.visible = false

func _update_poi() -> void:
	poi_display.poi = null
	if not goblin.is_walking:
		var poi : POI = quest_manager.get_poi(goblin.grid_position)
		if poi != null:
			poi_display.poi = poi

func _on_walk_state_changed(is_walking : bool) -> void:
	_update_play_pause()
	_update_poi()

func _on_has_path_changed(has_path : bool) -> void:
	_update_play_pause()

func _on_name_display_changed(new_text : String) -> void:
	new_text = new_text.to_upper()
	
	var size : int = 0
	var successful : bool = true
	for c in new_text:
		if not CHAR_SIZES.has(c):
			successful = false
			break
		
		size += CHAR_SIZES[c]
		
		if size > MAX_NAME_SIZE:
			successful = false
			break
		
		size += 1
	
	if successful:
		goblin.display_name = new_text
	else:
		name_display.text = goblin.display_name

const MAX_NAME_SIZE : int = 35

const CHAR_SIZES := {
	'A' : 3,
	'B' : 3,
	'C' : 3,
	'D' : 3,
	'E' : 3,
	'F' : 3,
	'G' : 3,
	'H' : 3,
	'I' : 3,
	'J' : 3,
	'K' : 3,
	'L' : 3,
	'M' : 5,
	'N' : 4,
	'O' : 3,
	'P' : 3,
	'Q' : 3,
	'R' : 3,
	'S' : 3,
	'T' : 3,
	'U' : 3,
	'V' : 3,
	'W' : 5,
	'X' : 3,
	'Y' : 3,
	'Z' : 3,
	' ' : 1,
	'0' : 3,
	'1' : 3,
	'2' : 3,
	'3' : 3,
	'4' : 3,
	'5' : 3,
	'6' : 3,
	'7' : 3,
	'8' : 3,
	'9' : 3,
	'!' : 1,
	'"' : 3,
	'#' : 5,
	'$' : 3,
	'%' : 5,
	'\'' : 1,
	'(' : 2,
	')' : 2,
	'*' : 3,
	'+' : 3,
	',' : 2,
	'-' : 3,
	'.' : 1,
	'/' : 3,
	':' : 1,
	';' : 2,
	'<' : 2,
	'=' : 3,
	'>' : 2,
	'?' : 3,
	'[' : 2,
	'\\' : 3,
	']' : 2,
	'_' : 5,
	'{' : 3,
	'|' : 1,
	'}' : 3,
	'~' : 4
}
