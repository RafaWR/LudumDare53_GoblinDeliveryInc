extends Node2D
class_name POIManager

@export var shop_timer_label : Label

@export var quest_attempt_delay : float
@export var quest_attempt_initial_delay : float
@export var shop_refresh_delay : float

var _pois : Array[POI] = []

@onready var _quest_attempt_timer : float = quest_attempt_initial_delay
var _shop_refresh_timer : float

func add_poi(poi : POI) -> void:
	_pois.append(poi)

func get_poi(pos : Vector2i) -> POI:
	for s in _pois:
		if s.board_position == pos:
			return s
	return null

func attempt_quest() -> void:
	for i in range(3): # attempts 3 times
		var poi : POI = _pois.pick_random()
		if poi.quest != null:
			continue
		
		var target : POI = poi
		while target == poi:
			target = _pois.pick_random()
		
		var quest : QuestItem = poi.quest_pack.get_quest()
		quest.to = target.board_position
		quest.from_name = poi.display_name
		quest.to_name = target.display_name
		
		poi.quest = quest
		return

func refresh_shops() -> void:
	for poi in _pois:
		var item1_type : Item.Type = Item.Type.BOOT if randf_range(0.0, 1.0) < 0.5 else Item.Type.BAG
		var item1 : Item = poi.item_pack.get_item(item1_type)
		
		var item2_type : Item.Type = Item.Type.GOBLIN if randf_range(0.0, 1.0) < 0.5 else (Item.Type.BAG if item1_type == Item.Type.BOOT else Item.Type.BOOT)
		var item2 : Item = poi.item_pack.get_item(item2_type)
		
		poi.set_shop_items(item1, item2)

func _process(delta : float) -> void:
	_quest_attempt_timer -= delta
	if _quest_attempt_timer <= 0.0:
		_quest_attempt_timer = quest_attempt_delay
		attempt_quest()
	
	_shop_refresh_timer -= delta
	if _shop_refresh_timer <= 0.0:
		_shop_refresh_timer = shop_refresh_delay
		refresh_shops()
	
	shop_timer_label.text = str(floori(_shop_refresh_timer))
