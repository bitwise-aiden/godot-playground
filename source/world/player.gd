class_name WorldPlayer extends CharacterBody2D


# Lifecycle methods

func _physics_process(
	_delta : float,
) -> void:
	var direction : Vector2 = Input.get_vector(
		"ui_left", "ui_right",
		"ui_up", "ui_down",
	)

	velocity = direction * WorldConstants.BLOCK_POSITION_SCALAR * WorldConstants.PLAYER_SPEED

	move_and_slide()
