extends Resource
class_name QuestPack

@export var small_item_names : Array[String] = []
@export var medium_item_names : Array[String] = []
@export var big_item_names : Array[String] = []
@export var reward_range : Vector2i
@export var base_sprite_amount : int
@export var stamp_sprite_amount : int

func get_quest() -> QuestItem:
	var item := QuestItem.new()
	item.reward = randi_range(reward_range.x, reward_range.y)
	item.size = randi_range(0, 2)
	item.base_sprite = randi_range(0, base_sprite_amount - 1)
	item.stamp_sprite = randi_range(0, stamp_sprite_amount - 1)
	
	match item.size:
		0:
			item.item_name = small_item_names.pick_random()
		1:
			item.item_name = medium_item_names.pick_random()
		2:
			item.item_name = big_item_names.pick_random()
	
	return item
