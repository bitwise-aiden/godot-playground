class_name Game extends Node2D


# Private variables

@onready var __camera : Camera2D = $camera
@onready var __dungeon : Dungeon = $dungeon
@onready var __player : Player = $player

var __moving : bool = false

# Lifecycle methods

func _ready() -> void:
	await get_tree().process_frame

	__dungeon.show_blocks()


func _process(
	delta: float,
) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if __moving:
			return

		__moving = true

		var mouse_coord : Vector2i = __dungeon.get_mouse_coord()

		if !__dungeon.is_ground_block(mouse_coord):
			__moving = false
			return

		var location : Vector2 = __dungeon.map_to_local(mouse_coord)

		await __player.move(__dungeon.to_global(location))

		if __dungeon.is_door_block(mouse_coord):
			__dungeon.spawn_room(mouse_coord)

			var tween : Tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(
				__camera,
				"position",
				__dungeon.get_camera_target() - Vector2(640.0, 528.0),
				0.5,
			)
	else:
		__moving = false
