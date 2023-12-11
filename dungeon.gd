class_name Dungeon extends Node2D


# Private variables

@onready var __layers : Array = get_children()

var __block_centre : Vector2i = Vector2i(2, 3)
var __block_locations : Array[Vector3i]


# Lifecycle methods

func _ready() -> void:
	await get_tree().process_frame

	for i in __layers.size():
		for coord in __layers[i].get_used_cells(0):
			var delta : Vector2i = coord - __block_centre

			__block_locations.append(Vector3i(delta.x, delta.y, i))
			__layers[i].erase_cell(0, coord)

	await get_tree().process_frame

	spawn_room(__block_centre)


# Public methods

func get_camera_target() -> Vector2:
	return __layers[0].to_global(__layers[0].map_to_local(__block_centre))


func get_mouse_coord() -> Vector2i:
	return __layers[0].local_to_map(
		__layers[0].get_local_mouse_position()
	)


func get_blocks() -> Array[Block]:
	var blocks : Array[Block] = []

	for layer in __layers:
		for child in layer.get_children(true):
			if child is Block:
				blocks.append(child)

	return blocks


func is_ground_block(
	coord : Vector2i,
) -> bool:
	return __layers[0].get_cell_source_id(0, coord) != -1


func is_door_block(
	coord : Vector2i,
) -> bool:
	var delta : Vector2i = __block_centre - coord

	return delta.length() == 3


func map_to_local(
	coord : Vector2i,
) -> Vector2:
	return __layers[0].map_to_local(coord)


func spawn_room(
	location : Vector2i,
) -> void:
	var prev_blocks : Dictionary = {}
	var curr_blocks : Dictionary = {}

	for block in get_blocks():
		prev_blocks[__block_location(block)] = null

	var offset : Vector2i = (location - __block_centre).clamp(-Vector2i.ONE, Vector2i.ONE)
	__block_centre += offset * 6

	var behind : bool = offset == offset.abs()

	for block_location in __block_locations:
		var coord : Vector2i = Vector2i(block_location.x, block_location.y) + __block_centre
		var layer : int = block_location.z

		__layers[layer].set_cell(0, coord, 1, Vector2i.ZERO, 1)

		curr_blocks[Vector3i(coord.x, coord.y, layer)] = null

	await get_tree().process_frame

	for block in get_blocks():
		var coord : Vector3i = __block_location(block)

		match [prev_blocks.has(coord), curr_blocks.has(coord)]:
			[true, false]:
				__erase_block(block, behind)
			[false, true]:
				__show_block(block)


func show_blocks() -> void:
	for block in get_blocks():
		__show_block(block)


# Private methods

func __block_location(
	block : Block,
) -> Vector3i:
	var parent : Node2D = block.get_parent()
	var layer : int = __layers.find(parent)
	var coord : Vector2i = __layers[layer].local_to_map(block.position)

	return Vector3i(coord.x, coord.y, layer)


func __show_block(
	block : Block,
) -> void:
	var layer : int = __block_location(block).z
	block.move_in(-200.0 if layer > 0 else 200.0)
	#block.z_index = layer + 1


func __erase_block(
	block : Block,
	behind : bool = false,
) -> void:
	var location = __block_location(block)

	var coord : Vector2i = Vector2i(location.x, location.y)
	var layer : int = location.z

	await block.move_out(-200.0 if layer > 0 else 200.0, behind)

	__layers[layer].erase_cell(0, coord)


