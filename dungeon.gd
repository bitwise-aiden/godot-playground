class_name Dungeon extends Node2D


# Private constants

const __DUNGEON_LAYER : Resource = preload("res://dungeon_layer.tscn")
const __DUNGEON_HEIGHT : int = 6


# Private variables

@onready var __layers : Array = get_children()

var __block_centre : Vector2i = Vector2i(2, 3)
var __block_locations : Array[Vector3i]
var __directions : Dictionary = {
	Vector3i(0, 0, -1) : Vector2(-1.0, +1.0),
	Vector3i(0, 0, +1) : Vector2(+1.0, -1.0),
	Vector3i(+1, 0, 0) : Vector2(-1.0, -1.0),
	Vector3i(-1, 0, 0) : Vector2(+1.0, +1.0),
	Vector3i(0, -1, 0) : Vector2(0.0, -1.0),
	Vector3i(0, +1, 0) : Vector2(0.0, +1.0),
}
var __direction_scalar : Vector2


# Lifecycle methods

func _ready() -> void:
	await get_tree().process_frame

	for i in __layers.size():
		for coord in __layers[i].get_used_cells(0):
			var delta : Vector2i = coord - __block_centre

			__block_locations.append(Vector3i(delta.x, i, delta.y))

	var ground : TileMap = __layers[0]
	var centre : Vector2 = ground.map_to_local(__block_centre)

	# Using offset angles to determine correct cells
	var north_east : Vector2 = ground.map_to_local(__block_centre + Vector2i.RIGHT)
	__direction_scalar = (north_east - centre).normalized()


# Public methods

func blocks_enter(
	direction : Vector3i,
	except : Array = [],
) -> void:
	var blocks_by_layer : Dictionary = get_blocks_by_layer(direction)
	var layers : Array = blocks_by_layer.keys()
	layers.sort()

	var ground_blocks : Array[Block] = __layers[0].get_blocks()
	var highest_block : Block = ground_blocks[0]

	for block : Block in ground_blocks:
		if !is_instance_valid(block) || except.find(__block_location(block)) != -1:
				continue

		if block.global_position.y > highest_block.global_position.y:
			highest_block = block

	var coord_to_y : Dictionary = {}
	for block : Block in ground_blocks:
		if !is_instance_valid(block) || except.find(__block_location(block)) != -1:
				continue

		var coord : Vector2i = __block_coord(block)

		if block == highest_block:
			coord_to_y[coord] = 1000
		else:
			var delta : Vector2i = __block_coord(highest_block) - coord

			coord_to_y[coord] = 1000 - delta.y - delta.x

	for layer : int in layers:
		for block : Block in blocks_by_layer[layer]:
			if !is_instance_valid(block) || except.find(__block_location(block)) != -1:
				continue

			var location : Vector3i = __block_location(block)
			var coord : Vector2i = Vector2i(location.x, location.z)

			__block_enter(block, Vector3i.UP, coord_to_y.get(coord, 0) + location.y * 2)

		await get_tree().create_timer(0.05).timeout


func blocks_exit(
	direction : Vector3i,
	except : Array = [],
) -> void:
	var blocks_by_layer : Dictionary = get_blocks_by_layer(direction)
	var layers : Array = blocks_by_layer.keys()
	layers.sort()

	for layer : int in layers:
		for block : Block in blocks_by_layer[layer]:
			if !is_instance_valid(block) || except.find(__block_location(block)) != -1:
				continue

			__block_exit(block, direction)

		await get_tree().create_timer(0.05).timeout


func get_block(location : Vector3i) -> Block:
	var coord : Vector2i = Vector2i(location.x, location.z)
	var layer : int = location.y

	for block in __layers[layer].get_blocks():
		if __block_coord(block) == coord:
			return block

	return null


func get_blocks() -> Array[Block]:
	var blocks : Array[Block] = []

	for layer in __layers:
		blocks += layer.get_blocks()

	return blocks


func get_blocks_by_layer(
	axis : Vector3i,
) -> Dictionary:
	var blocks_by_layer : Dictionary = {}

	for block in get_blocks():
		var location : Vector3i = __block_location(block)
		var coord : Vector2i = Vector2i(location.x, location.z)
		var layer : int = location.z

		var delta : Vector2i = __block_centre - coord
		var delta_axis : Vector2i = delta * Vector2i(axis.x, axis.z)

		var value : int = layer * axis.y + delta_axis.x + delta_axis.y

		if !value in blocks_by_layer:
			blocks_by_layer[value] = []

		blocks_by_layer[value].append(block)

	return blocks_by_layer


func get_camera_target() -> Vector2:
	return __layers[0].to_global(__layers[0].map_to_local(__block_centre))


func get_diagonal_scalar() -> Vector2:
	return __direction_scalar


func is_ground_block(
	coord : Vector2i,
) -> bool:
	return (
		__layers[0].get_cell_source_id(0, coord) != -1 &&
		__layers[1].get_cell_source_id(0, coord) == -1 &&
		__layers[2].get_cell_source_id(0, coord) == -1
	)



func is_door_block(
	coord : Vector2i,
) -> bool:
	var delta : Vector2i = __block_centre - coord

	return delta.length() == 3


func location_to_map(
	location : Vector2,
) -> Vector2i:
	var local_location : Vector2 = __layers[0].to_local(location)
	return __layers[0].local_to_map(local_location)


func map_to_locations(
	coord : Vector2i,
) -> Vector2:
	var local_location : Vector2 = __layers[0].map_to_local(coord)
	return __layers[0].to_global(local_location)


func spawn_room(
	location : Vector2i,
) -> void:
	var prev_blocks : Dictionary = {}
	var curr_blocks : Dictionary = {}

	var offset : Vector2i = (location - __block_centre).clamp(-Vector2i.ONE, Vector2i.ONE)
	var direction : Vector3i = Vector3i(offset.x, 0.0, offset.y)
	__block_centre += offset * 6

	for block in get_blocks():
		block.z_index -= 0 if direction.x + direction.y + direction.z < 0 else 1000
		prev_blocks[__block_location(block)] = null

	for block_location in __block_locations:
		var coord : Vector2i = Vector2i(block_location.x, block_location.z) + __block_centre
		var layer : int = block_location.y

		__layers[layer].set_cell(0, coord, 1, Vector2i.ZERO, 1)

		var new_location : Vector3i = Vector3i(coord.x, layer, coord.y)

		curr_blocks[new_location] = null
		prev_blocks.erase(new_location)

	await get_tree().process_frame

	blocks_exit(-direction, curr_blocks.keys())
	await blocks_enter(-direction, prev_blocks.keys())

	for to_delete : Vector3i in prev_blocks.keys():
		if to_delete in curr_blocks:
			continue

		__layers[to_delete.y].erase_cell(0, Vector2i(to_delete.x, to_delete.z))

	await get_tree().process_frame


# Private methods

func __block_coord(
	block : Block,
) -> Vector2i:
	var location : Vector3i = __block_location(block)

	return Vector2i(location.x, location.z)


func __block_enter(
	block : Block,
	direction : Vector3i,
	z_index : int,
) -> void:
	__block_index(block, z_index)
	await block.enter(__directions[direction] * __direction_scalar)
	#block.z_index = z_index

func __block_index(
	block : Block,
	z_index : int,
) -> void:
	await create_tween().tween_interval(0.2).finished
	block.z_index = z_index


func __block_exit(
	block : Block,
	direction : Vector3i,
) -> void:
	await block.exit(__directions[direction] * -__direction_scalar)


func __block_location(
	block : Block,
) -> Vector3i:
	var parent : Node2D = block.get_parent()
	var layer : int = __layers.find(parent)
	var coord : Vector2i = __layers[layer].local_to_map(block.position)

	return Vector3i(coord.x, layer, coord.y)
