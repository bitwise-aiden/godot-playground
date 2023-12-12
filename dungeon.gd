class_name Dungeon extends Node2D


# Private constants

const __DUNGEON_LAYER : Resource = preload("res://dungeon_layer.tscn")
const __DUNGEON_HEIGHT : int = 6


# Private variables

@onready var __layers : Array = get_children()

var __block_centre : Vector2i = Vector2i(2, 3)
var __block_locations : Array[Vector3i]
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

	for layer : int in layers:
		for block : Block in blocks_by_layer[layer]:
			if except.find(__block_location(block)) != -1:
				continue

			__block_enter(block, direction)

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
			if except.find(__block_location(block)) != -1:
				continue

			__block_exit(block, direction)

		await get_tree().create_timer(0.05).timeout


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
		var block_axis : Vector3i = __block_location(block) * axis
		var value : int = block_axis.x + block_axis.y + block_axis.z

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
	return __layers[0].get_cell_source_id(0, coord) != -1


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

	for block in get_blocks():
		prev_blocks[__block_location(block)] = null

	var offset : Vector2i = (location - __block_centre).clamp(-Vector2i.ONE, Vector2i.ONE)
	__block_centre += offset * 6

	var behind : bool = offset == offset.abs()

	for block_location in __block_locations:
		var coord : Vector2i = Vector2i(block_location.x, block_location.z) + __block_centre
		var layer : int = block_location.y

		__layers[layer].set_cell(0, coord, 1, Vector2i.ZERO, 1)

		curr_blocks[Vector3i(coord.x, layer, coord.y)] = null

	await get_tree().process_frame

	var direction : Vector3i = Vector3i(offset.x, 0.0, offset.y)

	blocks_exit(direction, curr_blocks.keys())
	blocks_enter(direction, prev_blocks.keys())


# Private methods

func __block_coord(
	block : Block,
) -> Vector2i:
	var location : Vector3i = __block_location(block)

	return Vector2i(location.x, location.z)


var __directions : Dictionary = {
	Vector3i(0, 0, -1) : Vector2(+1.0, -1.0),
	Vector3i(0, 0, +1) : Vector2(-1.0, +1.0),
	Vector3i(+1, 0, 0) : Vector2(+1.0, +1.0),
	Vector3i(-1, 0, 0) : Vector2(-1.0, -1.0),
	Vector3i(0, -1, 0) : Vector2(0.0, -1.0),
}

func __block_enter(
	block : Block,
	direction : Vector3i,
) -> void:
	await block.enter(__directions[direction] * __direction_scalar)


func __block_exit(
	block : Block,
	direction : Vector3i,
) -> void:
	await block.exit(__directions[direction] * __direction_scalar * -1)
	print(direction)

	var location = __block_location(block)

	var coord : Vector2i = Vector2i(location.x, location.z)
	var layer : int = location.y

	__layers[layer].erase_cell(0, coord)


func __block_location(
	block : Block,
) -> Vector3i:
	var parent : Node2D = block.get_parent()
	var layer : int = __layers.find(parent)
	var coord : Vector2i = __layers[layer].local_to_map(block.position)

	return Vector3i(coord.x, layer, coord.y)
