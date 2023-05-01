extends TileMap
class_name World

func get_tags(tile : Vector2i) -> Array[String]:
	var floor_data : TileData = get_cell_tile_data(0, tile)
	var terrain_data : TileData = get_cell_tile_data(1, tile)
	
	var tags : Array[String] = []
	if floor_data != null:
		tags.append(floor_data.get_custom_data("terrain_type"))
	if terrain_data != null:
		tags.append(terrain_data.get_custom_data("terrain_type"))
	
	return tags
