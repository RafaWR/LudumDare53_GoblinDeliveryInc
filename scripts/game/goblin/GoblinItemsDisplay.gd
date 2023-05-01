extends Node2D
class_name GoblinItemsDisplay

@onready var empty_boots : Sprite2D = $EmptyBoots
@onready var boots : ItemDisplay = $Boots
@onready var empty_bag : Sprite2D = $EmptyBag
@onready var bag : ItemDisplay = $Bag
@onready var speed_display : Label = $Speed

var goblin : Goblin:
	set(value):
		if goblin != null:
			goblin.quests_changed.disconnect(_update_items)
		
		goblin = value
		
		_update_items()
		
		if goblin != null:
			goblin.items_changed.connect(_update_items)

func _update_items() -> void:
	empty_boots.visible = goblin == null or goblin.boots == null
	boots.visible = goblin != null
	empty_bag.visible = goblin == null or goblin.bag == null
	bag.visible = goblin != null
	
	if goblin != null:
		boots.display(goblin.boots)
		bag.display(goblin.bag)
	
	_update_speed()

func _update_speed() -> void:
	speed_display.text = str(goblin.speed) if goblin != null else "--"
