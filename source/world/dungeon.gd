class_name WorldDungeon extends Node2D


# Private constants

const __DATA_BLOCK_MISSING : Resource = preload("res://source/data/blocks/block_missing.tres")
const __DATA_BLOCKS : Array[Resource] = [
	preload("res://source/data/blocks/block_sand.tres"),
	preload("res://source/data/blocks/block_stone.tres"),
]

const __WORLD_BLOCK : Resource = preload("res://source/world/block.tscn")
const __WORLD_ROOM : Resource = preload("res://source/world/room.tscn")


# Lifecycle methods

func _ready() -> void:
	var room : WorldRoom = __WORLD_ROOM.instantiate()
	add_child(room)

	var size : int = 6

	for x : int in size:
		for y : int in size:
			for z : int in size:
				if y in [1, 2] && 3 in [x, z]:
					continue

				if x == 0 || y == 0 || z == 0:
					room.add_block(
						spawn_block(Vector3i(x, y, z), __DATA_BLOCKS[0]),
					)

	room.add_block(
		spawn_block(Vector3i(6, 0, 3), __DATA_BLOCKS[0]),
	)
	room.add_block(
		spawn_block(Vector3i(3, 0, 6), __DATA_BLOCKS[0]),
	)

	var directions : Array[Vector3i] = [
		Vector3i.DOWN,
		Vector3i.RIGHT,
		Vector3i.FORWARD,
		Vector3i.UP,
		Vector3i.LEFT,
		Vector3i.BACK,
	]

	while true:
		for j : int in  directions.size():
			await room.transition_in(directions[j])
			await create_tween().tween_interval(0.5).finished
			await room.transition_out(directions[(j + 1) % directions.size()])
			await create_tween().tween_interval(0.5).finished


# Public methods

func spawn_block(
	coord : Vector3i,
	data : DataBlock,
) -> WorldBlock:
	var block : WorldBlock = __WORLD_BLOCK.instantiate()

	block.coord = coord
	block.data = data

	return block
