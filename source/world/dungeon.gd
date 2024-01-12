class_name WorldDungeon extends Node2D

# Private constants

const __DATA_BLOCK_MISSING : Resource = preload("res://source/data/blocks/block_missing.tres")
const __DATA_BLOCKS : Array[Resource] = [
	preload("res://source/data/blocks/block_sand.tres"),
	preload("res://source/data/blocks/block_stone.tres"),
]

const __WORLD_BLOCK : Resource = preload("res://source/world/block.tscn")


# Lifecycle methods

func _ready() -> void:
	var size : int = 6

	for x in size:
		for y in size:
			for z in size:
				if y in [1, 2] && 3 in [x, z]:
					continue

				if x == 0 || y == 0 || z == 0:
					add_block(Vector3i(x, y, z), __DATA_BLOCKS[0])

	add_block(Vector3i(6, 0, 3), __DATA_BLOCKS[0])
	add_block(Vector3i(3, 0, 6), __DATA_BLOCKS[0])


# Public methods

func add_block(
	coord : Vector3i,
	data : DataBlock,
) -> WorldBlock:
	var block : WorldBlock = __WORLD_BLOCK.instantiate()
	block.coord = coord
	block.data = data

	add_child(block)

	return block


