extends TileMap


# Lifecycle methods

func _ready() -> void:
	var tween : Tween = create_tween()

	var original : Vector2i = tile_set.tile_size
	tile_set.tile_size *= 10

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(
		tile_set,
		"tile_size",
		original,
		0.5
	)
