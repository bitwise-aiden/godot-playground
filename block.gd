class_name Block extends Node2D


# Private constants

const __SPRITES : Array[Texture] = [
	preload("res://stone_tile_0.png"),
	preload("res://stone_tile_1.png"),
	preload("res://stone_tile_2.png"),
]


# Private variables

@onready var __sprite : Sprite2D = $sprite


# Lifecycle methods

func _ready() -> void:
	var rand : PackedInt64Array = rand_from_seed(position.x + position.y)
	__sprite.texture = __SPRITES[rand[0] % __SPRITES.size()]
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
		0.5 ,
	)

	await tween.finished


func move_out(
	to : float,
	behind : bool
) -> void:
	z_index += -10 if behind else 10

	var tween : Tween = create_tween()

	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		__sprite,
		"position:y",
		to,
		0.5 + randf() * 0.2,
	)

	await tween.finished

	__sprite.visible = false


