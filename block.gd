class_name Block extends Node2D


# Private constants

const __SPRITES : Array[Texture] = [
	preload("res://block_0.png"),
	preload("res://block_1.png"),
	preload("res://block_2.png"),
]


# Private variables

@onready var __sprite : Sprite2D = $sprite


# Lifecycle methods

func _ready() -> void:
	__sprite.texture = __SPRITES[randi() % __SPRITES.size()]
	__sprite.visible = false


# Public methods

func move_in(
	from : float,
) -> void:
	__sprite.visible = true
	__sprite.position.y = from

	var tween : Tween = create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(
		__sprite,
		"position:y",
		0.0,
		0.5 + randf() * 0.2,
	)

	await tween.finished


func move_out(
	to : float,
) -> void:
	var tween : Tween = create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(
		__sprite,
		"position:y",
		to,
		0.5 + randf() * 0.2,
	)

	await tween.finished

	__sprite.visible = false


