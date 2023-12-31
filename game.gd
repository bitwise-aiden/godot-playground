class_name Game extends Node2D


# Private variables

@onready var __camera : Camera2D = $camera
@onready var __dungeon : Dungeon = $dungeon
@onready var __player : Player = $player

var __prev_player_coord : Vector2i
var __prev_player_position : Vector2


# Lifecycle methods

func _ready() -> void:
	await get_tree().process_frame

	__dungeon.blocks_enter(Vector3i.DOWN)
	__player.set_direction_scalar(
		__dungeon.get_diagonal_scalar()
	)


func _process(
	_delta: float,
) -> void:
	var player_coord : Vector2i = __dungeon.location_to_map(__player.position)

	if !__dungeon.is_ground_block(player_coord):
		__player.position = __prev_player_position
		return

	__prev_player_position = __player.position

	var block : Block = __dungeon.get_block(Vector3i(player_coord.x, 0, player_coord.y))
	__player.z_index = block.z_index + 2

	if player_coord == __prev_player_coord:
		return

	if __dungeon.is_door_block(player_coord):
		__dungeon.spawn_room(player_coord)

		var tween : Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(
			__camera,
			"position",
			__dungeon.get_camera_target() - Vector2(960.0, 760.0),
			0.8,
		)

	__prev_player_coord = player_coord
