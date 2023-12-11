class_name Player extends Sprite2D


# Private variables

var __direction_scalar : Vector2


# Lifecycle methods

func _physics_process(delta: float) -> void:
	var direction : Vector2 = Input.get_vector(
		"ui_left", "ui_right",
		"ui_up", "ui_down",
	).normalized()

	position += direction * __direction_scalar * delta * 200.0

# Public methods

func set_direction_scalar(
	scalar : Vector2,
) -> void:
	__direction_scalar = scalar
