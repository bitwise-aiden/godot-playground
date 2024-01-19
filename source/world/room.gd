class_name WorldRoom extends Node2D


# Private variables

var __blocks : Dictionary = {}


# Public methods

func add_block(
	block : WorldBlock,
) -> void:
	assert(!__blocks.has(block.coord), "Block at coord `%s` already exists." % block.coord)

	__blocks[block.coord] = block
	add_child(block)


func transition_in(
	direction : Vector3i,
) -> void:
	var offset : Vector2 = WorldConstants.coord_to_world(direction) * 20.0
	await __transition(direction, offset, Vector2.ZERO)


func transition_out(
	direction : Vector3i,
) -> void:
	var offset : Vector2 = WorldConstants.coord_to_world(direction) * 20.0
	await __transition(direction, Vector2.ZERO, offset)


# Private methods

func __coords_by_layer(
	direction : Vector3i,
) -> Dictionary:
	var coords_by_layer : Dictionary = {}

	for coord : Vector3i in __blocks.keys():
		var masked_coord = coord * direction
		var layer : int = (masked_coord.x + masked_coord.y + masked_coord.z)

		if !coords_by_layer.has(layer):
			coords_by_layer[layer] = []

		coords_by_layer[layer].append(coord)

	return coords_by_layer


func __transition(
	direction : Vector3i,
	from : Vector2,
	to : Vector2,
) -> void:
	var ordering : int = -1 if from == Vector2.ZERO else 1

	var coords_by_layer : Dictionary = __coords_by_layer(direction)

	var sorted_layers : Array = coords_by_layer.keys()
	sorted_layers.sort_custom(
		func(a, b):
			return a * ordering < b * ordering
	)

	var tween : Tween

	for i : int in sorted_layers.size():
		tween = create_tween()

		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		tween.tween_interval(0.1 * i)
		tween.tween_interval(0.0)

		var layer : int = sorted_layers[i]

		for coord : Vector3i in coords_by_layer[layer]:
			var block : WorldBlock = __blocks[coord]
			block.offset = from

			tween.parallel().tween_property(
				block,
				"offset",
				to,
				0.2 + randf() * 0.3
			)

	await tween.finished
