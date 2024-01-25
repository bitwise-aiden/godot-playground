class_name WorldDungeon extends Node2D

#
# NOTE: This script is mostly testing logic for the time being. It will
#		be updated to house more permanent features in the future.
#


# Private constants

const __DATA_BLOCK_MISSING : Resource = preload("res://source/data/blocks/block_missing.tres")
const __DATA_BLOCKS : Array[Resource] = [
	preload("res://source/data/blocks/block_sand.tres"),
	preload("res://source/data/blocks/block_stone.tres"),
]

const __WORLD_BLOCK : Resource = preload("res://source/world/block.tscn")
const __WORLD_PLAYER : Resource = preload("res://source/world/player.tscn")
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
	await room.transition_in(Vector3i.DOWN)

	var player_coord : Vector3i = Vector3i(3, 0, 3)

	var player : WorldPlayer = spawn_player(player_coord)
	player.position = Vector2.UP * 200.0
	player.z_index = 100
	player.coord_changed.connect(
		func(c : Vector3i):
			var b : WorldBlock = room.get_block(c)

			if b:
				b.modulate = Color(randf(), randf(), randf())

			$test.position = player.global_position
	)

	add_child(player)

	var tween : Tween = create_tween()

	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		player,
		"position",
		WorldConstants.coord_to_world(player_coord) - Vector2(0.0, 8.0),
		0.5
	)

	await tween.finished

	player.z_index = 1


# Public methods

func spawn_block(
	coord : Vector3i,
	data : DataBlock,
) -> WorldBlock:
	var block : WorldBlock = __WORLD_BLOCK.instantiate()

	block.collider = WorldBlock.Collider.Bottom if coord.y == 1 else WorldBlock.Collider.None
	block.coord = coord
	block.data = data

	return block


func spawn_player(
	coord : Vector3i,
) -> WorldPlayer:
	var player : WorldPlayer = __WORLD_PLAYER.instantiate()

	player.coord = coord
	player.position = WorldConstants.coord_to_world(coord) - Vector2(0.0, 8.0)

	return player
