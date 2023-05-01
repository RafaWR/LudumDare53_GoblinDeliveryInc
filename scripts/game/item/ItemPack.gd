extends Resource
class_name ItemPack

@export var boot_items : Array[Item]
@export var bag_items : Array[Item]
@export var goblin_items : Array[Item]

func get_item(type : Item.Type) -> Item:
	match type:
		Item.Type.BOOT:
			return boot_items.pick_random()
		Item.Type.BAG:
			return bag_items.pick_random()
		Item.Type.GOBLIN:
			return goblin_items[Goblin.get_random_variation()]
	return null
