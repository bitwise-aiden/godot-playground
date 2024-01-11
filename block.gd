class_name Block extends Node2D


# Public signals

signal z_index_changed(value : int)


# Private constants

const __SPRITES : Array[Texture] = [
	preload("res://stone_tile_0.png"),
	preload("res://stone_tile_1.png"),
	preload("res://stone_tile_2.png"),
]


# Private variables

@onready var __sprite : Sprite2D = $sprite
@onready var __z_index : Label = $z_index


# Lifecycle methods

func _ready() -> void:
	var rand : PackedInt64Array = rand_from_seed(global_position.x + global_position.y)
	__sprite.texture = __SPRITES[rand[0] % __SPRITES.size()]
	__sprite.visible = false


func _set(property: StringName, value: Variant) -> bool:
	if property == "z_index":
		__z_index.text = "%d" % value
		z_index_changed.emit(value)

	return false

# Public methods

func enter(
	direction : Vector2,
) -> void:
	__sprite.visible = true
	__sprite.position = direction * 200.0

	var tween : Tween = create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(
		__sprite,
		"position",
		Vector2.ZERO,
		0.2 + randf() * 0.2,
	)

	await tween.finished


func exit(
	direction : Vector2,
) -> void:
	var tween : Tween = create_tween()

	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		__sprite,
		"position",
		direction * 200.0,
		0.2 + randf() * 0.2,
	)

	await tween.finished

	__sprite.visible = false
