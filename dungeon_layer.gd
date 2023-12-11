class_name DungeonLayer extends TileMap


# Public methods

func get_blocks() -> Array[Block]:
	var blocks : Array[Block] = []

	for child in get_children(true):
		if child is Block:
			blocks.append(child)

	return blocks
