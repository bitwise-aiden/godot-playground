class_name Player extends Sprite2D


# Private variables

var __moving : bool = false


# Public methods

func move(
	location : Vector2,
) -> void:
	if __moving:
		return

	var tween : Tween = create_tween()
	tween.tween_property(
		self,
		"position",
		location,
		0.5,
	)

	await tween.finished

	__moving = false
