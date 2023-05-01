@tool
extends Sprite2D
class_name POI

signal quest_changed(quest : QuestItem)
signal shop_updated(items : Array[ShopItem])

@export var board_position : Vector2i:
	set(value):
		board_position = value
		position = board_position * Globals.PPT

@export_range(0, 8) var variation : int:
	set(value):
		variation = value
		frame_coords.x = variation

@export var display_name : String

@export var quest_pack : QuestPack
@export var item_pack : ItemPack

@onready var balloon : QuestItemDisplay = $QuestBalloon
@onready var balloon_animation : AnimationPlayer = $QuestBalloon/AnimationPlayer

var quest : QuestItem:
	set(value):
		quest = value
		balloon.display(quest)
		balloon_animation.play("pop")
		
		quest_changed.emit(quest)

var shop_items : Array[ShopItem] = [ ShopItem.new(), ShopItem.new() ]

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	get_parent().add_poi(self)

func set_shop_items(item1 : Item, item2 : Item) -> void:
	shop_items[0].item = item1
	shop_items[0].price = randi_range(item1.price_range.x, item1.price_range.y)
	
	shop_items[1].item = item2
	shop_items[1].price = randi_range(item2.price_range.x, item2.price_range.y)
	
	shop_updated.emit(shop_items)

func buy_item(id : int) -> void:
	shop_items[id].item = null
	shop_items[id].price = -1
	
	shop_updated.emit(shop_items)

class ShopItem:
	var item : Item
	var price : int
