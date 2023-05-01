extends Node2D
class_name GoblinQuestsDisplay

@export var quest_item_display_scene : PackedScene

@onready var locked_slots : Array = [ $Locked0, $Locked1, $Locked2 ]

var _displays : Array[Node] = []

var goblin : Goblin:
	set(value):
		if goblin != null:
			goblin.quests_changed.disconnect(_update_quests)
		
		goblin = value
		
		_update_quests()
		
		if goblin != null:
			goblin.quests_changed.connect(_update_quests)

func _update_quests() -> void:
	for d in _displays:
		d.queue_free()
	_displays.clear()
	
	if goblin == null:
		for s in locked_slots:
			s.visible = false
	else:
		var i : int = -1
		for q in goblin.quests:
			i += 1
			var display : QuestItemDisplay = quest_item_display_scene.instantiate()
			_displays.append(display)
			add_child(display)
			display.position = Vector2(12.0 * i, 0.0)
			display.display(q)
		
		for s in range(3):
			locked_slots[s].visible = s >= 0 and s >= goblin.quest_slots
