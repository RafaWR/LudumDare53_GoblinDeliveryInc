extends Node
class_name POIDisplay

@onready var goblin_display : GoblinDisplay = get_parent()

@onready var empty_house : Sprite2D = $EmptyHouse
@onready var house : Sprite2D = $House
@onready var empty_quest_item : Sprite2D = $EmptyQuestItem
@onready var quest_item : QuestItemDisplay = $QuestItem
@onready var quest_item_button : Hoverable = $QuestItem/Button
@onready var shop_items : Array = [ $Item1, $Item2 ]
@onready var shop_item_buttons : Array = [ $Item1/Inspectable, $Item2/Inspectable ]
@onready var shop_item_prices : Array = [ $Item1Price, $Item2Price ]
@onready var confirm_button : Hoverable = $ConfirmButton/Button
@onready var confirm_button_label : Label = $ConfirmButton/Label

enum Slot
{
	NONE,
	QUEST_ITEM,
	ITEM1,
	ITEM2
}

var _selected := Slot.NONE
var _hovered : Hoverable

var poi : POI:
	set(value):
		if poi == value:
			return
		
		if poi != null:
			poi.quest_changed.disconnect(_update_quest_item)
			poi.shop_updated.disconnect(_update_shop_items)
		
		poi = value
		
		empty_house.visible = poi == null
		house.visible = poi != null
		
		if poi == null:
			empty_quest_item.visible = true
			quest_item.visible = false
			
			_update_shop_items([])
			
			_set_selected(Slot.NONE)
		else:
			poi.quest_changed.connect(_update_quest_item)
			poi.shop_updated.connect(_update_shop_items)
			
			_update_quest_item(poi.quest)
			_update_shop_items(poi.shop_items)
			
			house.frame_coords.x = poi.frame_coords.x

func _ready() -> void:
	quest_item_button.hovered.connect(_on_hover.bind(quest_item_button))
	confirm_button.hovered.connect(_on_hover.bind(confirm_button))
	shop_item_buttons[0].hovered.connect(_on_hover.bind(shop_item_buttons[0]))
	shop_item_buttons[1].hovered.connect(_on_hover.bind(shop_item_buttons[1]))

func receive_input(input : InputEvent) -> void:
	if input.is_action("interact_1"):
		if _hovered != null:
			_select_hovered()
	elif input.is_action("interact_2") or input.is_action("cancel"):
		_set_selected(Slot.NONE)

func _update_quest_item(quest : QuestItem) -> void:
	empty_quest_item.visible = quest == null
	quest_item.visible = quest != null
	
	if quest != null:
		quest_item.display(quest)

func _update_shop_items(items : Array[POI.ShopItem]) -> void:
	if items.is_empty():
		shop_items[0].visible = false
		shop_items[1].visible = false
		
		shop_item_prices[0].text = "-"
		shop_item_prices[1].text = "-"
		
		return
	
	if _selected == Slot.ITEM1 or _selected == Slot.ITEM2:
		_set_selected(Slot.NONE)
	
	shop_items[0].display(items[0].item)
	shop_items[1].display(items[1].item)
	
	shop_item_prices[0].text = str(items[0].price) if items[0].price > -1 else "-"
	shop_item_prices[1].text = str(items[1].price) if items[1].price > -1 else "-"

func _set_selected(slot : Slot) -> void:
	_selected = slot
	
	confirm_button.get_parent().visible = slot != Slot.NONE
	
	if slot == Slot.QUEST_ITEM:
		confirm_button_label.text = "take"
	elif slot == Slot.ITEM1 or slot == Slot.ITEM2:
		confirm_button_label.text = "buy"

func _select_hovered() -> void:
	if _hovered == confirm_button:
		if _selected == Slot.QUEST_ITEM:
			if goblin_display.goblin.add_quest(poi.quest):
				poi.quest = null
				_set_selected(Slot.NONE)
				
				SoundSystem.play(Sound.BUY)
		
		elif _selected == Slot.ITEM1:
			if goblin_display.goblin.money_handler.take_money(poi.shop_items[0].price):
				goblin_display.goblin.add_item(poi.shop_items[0].item)
				poi.buy_item(0)
				
				SoundSystem.play(Sound.BUY)
		
		elif _selected == Slot.ITEM2:
			if goblin_display.goblin.money_handler.take_money(poi.shop_items[1].price):
				goblin_display.goblin.add_item(poi.shop_items[1].item)
				poi.buy_item(1)
				
				SoundSystem.play(Sound.BUY)
		
	elif _hovered == quest_item_button:
		_set_selected(Slot.QUEST_ITEM)
	elif _hovered == shop_item_buttons[0]:
		_set_selected(Slot.ITEM1)
	elif _hovered == shop_item_buttons[1]:
		_set_selected(Slot.ITEM2)

func _on_hover(hovered : bool, hoverable : Hoverable) -> void:
	if hovered:
		_hovered = hoverable
	elif _hovered == hoverable:
		_hovered = null
