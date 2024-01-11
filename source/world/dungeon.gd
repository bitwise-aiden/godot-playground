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
				if x == 0 || y == 0 || z == 0:
					var block : WorldBlock = __WORLD_BLOCK.instantiate()
					block.coord = Vector3i(x, y, z)

					var index : int = rand_from_seed(hash(block.coord))[0] % __DATA_BLOCKS.size()
					block.data = __DATA_BLOCKS[index]

					block.position = Vector2(
						z - x,
						(z + x) * 0.5 - y,
					) * 32.0
					block.z_index = y

					add_child(block)
