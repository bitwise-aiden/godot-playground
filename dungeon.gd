class_name Dungeon extends TileMap


# Private variables

var __block_centre : Vector2i
var __block_locations : Array[Vector3i]


# Lifecycle methods

func _ready() -> void:
	await get_tree().process_frame

	__block_centre = Vector2i.ZERO

	for layer in get_layers_count():
		for coord in get_used_cells(layer):
			__block_locations.append(Vector3i(coord.x, coord.y, layer))

			if layer == 0:
				__block_centre += coord

	__block_centre /= get_used_cells(0).size()


# Public methods

func get_mouse_coord() -> Vector2i:
	return local_to_map(
		get_local_mouse_position()
	)


func is_ground_block(
	coord : Vector2i,
) -> bool:
	return get_cell_source_id(0, coord) != -1


func spawn_room(
	location : Vector2i,
) -> void:
	var existing_blocks : Array[Block] = []
	var ignored_blocks : Array[Vector3i] = []

	for child in get_children(true):
		if child is Block:
			existing_blocks.append(child)

	var offset : Vector2i = (location - __block_centre).clamp(-Vector2i.ONE, Vector2i.ONE)

	for block_location in __block_locations:
		var coord : Vector2i = Vector2i(block_location.x, block_location.y) + offset * 6
		var layer : int = block_location.z

		set_cell(layer, coord, 1, Vector2i.ZERO, 1)

		ignored_blocks.append(Vector3i(coord.x, coord.y, layer))

	await get_tree().process_frame

	for block in existing_blocks:
		if ignored_blocks.find(__block_location(block)) != -1:
			continue

		__erase_block(block)

	show_blocks()


func show_blocks() -> void:
	for child in get_children(true):
		if child is Block:
			var layer : int = __block_layer(child)
			child.move_in(-200.0 if layer > 0 else 200.0)
			child.z_index = layer + 1


# Private methods

func __block_coord(
	block : Block,
) -> Vector2i:
	return local_to_map(block.position)


func __block_layer(
	block : Block,
) -> int:
	var coord : Vector2i = local_to_map(block.position)

	for layer : int in get_layers_count():
		if get_cell_source_id(layer, coord) != -1:
			return layer

	return -1


func __block_location(
	block : Block,
) -> Vector3i:
	var coord : Vector2i = __block_coord(block)
	var layer : int = __block_layer(block)

	return Vector3i(coord.x, coord.y, layer)


func __set_block(
	location : Vector3i,
) -> void:
	pass


func __erase_block(
	block : Block,
) -> void:
	var coord : Vector2i = local_to_map(block.position)
	var layer : int = __block_layer(block)

	await block.move_out(-200.0)

	erase_cell(layer, coord)


