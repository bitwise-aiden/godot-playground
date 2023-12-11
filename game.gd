class_name Game extends Node2D


# Private variables

@onready var __camera : Camera2D = $camera
@onready var __dungeon : Dungeon = $dungeon
@onready var __player : Player = $player

var __prev_player_coord : Vector2i


# Lifecycle methods

func _ready() -> void:
	await get_tree().process_frame

	__dungeon.show_blocks()
	__player.set_direction_scalar(
		__dungeon.get_diagonal_scalar()
	)


func _process(
	delta: float,
) -> void:
	var player_coord : Vector2i = __dungeon.location_to_map(__player.position)

	if player_coord == __prev_player_coord:
		return

	if __dungeon.is_door_block(player_coord):
		__dungeon.spawn_room(player_coord)

		var tween : Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(
			__camera,
			"position",
			__dungeon.get_camera_target() - Vector2(640.0, 528.0),
			0.5,
		)

	__prev_player_coord = player_coord
