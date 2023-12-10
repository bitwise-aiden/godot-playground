class_name Game extends Node2D


# Private variables

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
		print(mouse_coord)

		if !__dungeon.is_ground_block(mouse_coord):
			__moving = false
			return

		var location : Vector2 = __dungeon.map_to_local(mouse_coord)

		__player.move(__dungeon.to_global(location))

		if mouse_coord in [Vector2i(-1, 3), Vector2i(2, 0), Vector2i(5, 3), Vector2i(2, 6)]:
			__dungeon.spawn_room(mouse_coord)
	else:
		__moving = false
