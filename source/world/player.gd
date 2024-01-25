class_name WorldPlayer extends CharacterBody2D


# Public signals

signal coord_changed(coord : Vector3i)


# Public variables

var coord : Vector3i :
	set(value):
		coord = value

		coord_changed.emit(coord)



# Lifecycle methods

func _physics_process(
	_delta : float,
) -> void:
	__move()
	__check_coord()


# Private methods

func __check_coord() -> void:
	var new_coord : Vector3i = WorldConstants.world_to_coord(position)

	if coord != new_coord:
		coord = new_coord


func __move() -> void:
	var direction : Vector2 = Input.get_vector(
		"ui_left", "ui_right",
		"ui_up", "ui_down",
	)

	velocity = direction * WorldConstants.BLOCK_POSITION_SCALAR * WorldConstants.PLAYER_SPEED

	move_and_slide()
