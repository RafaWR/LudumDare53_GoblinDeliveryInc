extends Node

@export var goblin_scene : PackedScene

@export var world : World

@export var goblins_label : Label
@export var goblin_display : GoblinDisplay
@export var goblin_path_builder : GoblinPathBuilder
@export var money_handler : MoneyHandler

@export var starting_goblin_position : Vector2i

var _goblins : Array[Goblin]

var _hovered_goblin : Goblin
var _selected_goblin : Goblin

var _added_goblins : int

func _ready() -> void:
	add_goblin(starting_goblin_position)

func _input(event : InputEvent) -> void:
	if event.is_echo() or not event.is_pressed():
		return
	
	if event.is_action("interact_1"):
		if _hovered_goblin != null:
			if _hovered_goblin == _selected_goblin:
				deselect_goblin()
			select_goblin(_hovered_goblin)
	elif event.is_action("interact_2"):
		if _selected_goblin != null:
			deselect_goblin()
	elif event.is_action("cancel"):
		if _selected_goblin != null:
			deselect_goblin()
			Globals.cancel_processed()
	elif event.is_action("confirm"):
		pass # TODO confirm path

func add_goblin(position : Vector2i, variation : int = -1) -> void:
	var goblin : Goblin = goblin_scene.instantiate()
	goblin.money_handler = money_handler
	goblin.variation = variation
	goblin.grid_position = position
	world.add_child(goblin)
	goblin.position = Vector2i(Globals.PPT, Globals.PPT) / 2
	
	_added_goblins += 1
	_goblins.append(goblin)
	
	goblin.display_name = "GOBLIN " + str(_added_goblins)
	
	goblin.hitbox.hovered.connect(_on_goblin_hovered.bind(goblin))
	goblin.added_goblin_item.connect(_on_goblin_bought)
	
	update_goblins_label()

func select_goblin(goblin : Goblin) -> void:
	goblin.selected = true
	_selected_goblin = goblin
	
	goblin_display.goblin = goblin
	goblin_path_builder.goblin = goblin

func deselect_goblin() -> void:
	if _selected_goblin == null:
		return
	
	_selected_goblin.selected = false
	_selected_goblin = null
	
	goblin_display.goblin = null
	goblin_path_builder.goblin = null

func update_goblins_label() -> void:
	goblins_label.text = str(min(_goblins.size(), 999))

func _on_goblin_hovered(hovered : bool, goblin : Goblin) -> void:
	if hovered:
		_hovered_goblin = goblin
	elif goblin == _hovered_goblin:
		_hovered_goblin = null

func _on_goblin_bought(item : Item, spawn_position : Vector2i) -> void:
	var variation : int = roundi(item.get_effect(ItemEffect.Type.GOBLIN_TYPE))
	add_goblin(spawn_position, variation)
