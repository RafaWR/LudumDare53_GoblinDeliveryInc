extends Node2D
class_name Goblin

const TILER_PER_SPEED : float = 15.0

const TILE_SPEED_TAGS := {
	"river" : 0.2,
	"forest" : 0.5
}

static func get_random_variation() -> int:
	if randf_range(0.0, 1.0) < 0.05:
		# shiny :D
		return 7
	else:
		return randi_range(0, 6)

signal walk_state_changed(is_walking : bool, can_walk : bool)
signal quests_changed()
signal items_changed()
signal added_goblin_item(item : Item, spawn_position : Vector2i)

@export_node_path("Hoverable") var hitbox_path : NodePath
var hitbox : Hoverable:
	get:
		return get_node(hitbox_path)

@export var speed : int

@onready var world : World = get_parent()
var money_handler : MoneyHandler

@onready var sprite : Sprite2D = $Sprite
@onready var path : GoblinPath = $Path
@onready var animation : AnimationPlayer = $AnimationPlayer

var variation : int

var grid_position : Vector2i

var display_name : String

var quests : Array[QuestItem] = []
var quest_slots : int = 1:
	set(value):
		quest_slots = value
		quests_changed.emit()

var boots : Item:
	set(value):
		if boots != null:
			speed -= boots.get_effect(ItemEffect.Type.SPEED)
		
		boots = value
		
		if boots != null:
			speed += boots.get_effect(ItemEffect.Type.SPEED)
		
		items_changed.emit()
var bag : Item:
	set(value):
		if bag != null:
			quest_slots -= bag.get_effect(ItemEffect.Type.CARRY_SPACE)
		
		bag = value
		
		if bag != null:
			quest_slots += bag.get_effect(ItemEffect.Type.CARRY_SPACE)
		
		items_changed.emit()

var is_walking : bool:
	set(value):
		if is_walking == value:
			return
		is_walking = value
		
		if not is_walking:
			if path.has_path():
				sprite.position = grid_position * Globals.PPT
				path.reset(grid_position)
		
		walk_state_changed.emit(is_walking)
		inspection_updated.emit()
		
		animation.play("walk" if is_walking else "idle", 0.25)

var selected : bool:
	set(value):
		if selected == value:
			return
		selected = value
		path.selected = value
		
		z_index += 2 if selected else -2
		sprite.frame_coords.y += 1 if selected else -1

func _ready() -> void:
	path.path_updated.connect(_on_path_updated)
	path.finished_path.connect(_on_finished_path)
	path.has_path_changed.connect(_on_has_path_changed)
	
	path.reset(grid_position)
	sprite.position = grid_position * Globals.PPT
	
	if variation == -1:
		variation = get_random_variation()
	sprite.frame_coords.x = variation
	
	if variation == 7:
		$Sprite/Shimmer.visible = true

func add_quest(quest : QuestItem) -> bool:
	if quests.size() >= quest_slots:
		return false
	
	quests.append(quest)
	quests_changed.emit()
	
	return true

func add_item(item : Item) -> void:
	match item.type:
		Item.Type.BOOT:
			boots = item
		Item.Type.BAG:
			bag = item
		Item.Type.GOBLIN:
			added_goblin_item.emit(item, grid_position + Vector2i(0, -1))

func _on_path_updated() -> void:
	inspection_updated.emit()

func _on_finished_path() -> void:
	is_walking = false
	
	for i in range(quests.size() - 1, -1, -1):
		if quests[i].to == grid_position:
			money_handler.add_money(quests[i].reward)
			quests.remove_at(i)
			quests_changed.emit()

func _on_has_path_changed(has_path : bool) -> void:
	is_walking = is_walking and has_path

func _process(delta : float) -> void:
	if is_walking:
		var tile : Vector2i = path.get_current_tile()
		var tile_tags : Array[String] = world.get_tags(tile)
		var speed_multiplier : float = 1.0
		if not tile_tags.has("bridge"):
			for tag in tile_tags:
				if TILE_SPEED_TAGS.has(tag):
					speed_multiplier *= TILE_SPEED_TAGS[tag]
		
		var total_speed : float = speed * speed_multiplier * delta / TILER_PER_SPEED
		var position : Vector2 = path.move(total_speed) * Globals.PPT
		
		var diff : float = position.x - sprite.position.x
		if diff != 0.0:
			sprite.flip_h = diff < 0
		
		sprite.position = position
		grid_position = tile
		animation.speed_scale = speed_multiplier

signal inspection_updated()
func inspect() -> String:
	if not path.has_path():
		return "\njust chilling"
	
	var point : Vector2i = path.get_last_point()
	var point_str : String = str(point.x) + "x " + str(point.y) + "y"
	
	if is_walking:
		return "\nwalking towards " + point_str
	return "\nplanning route to " + point_str
