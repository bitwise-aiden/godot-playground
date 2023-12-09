extends TileMap


# Lifecycle methods

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout

	for child in get_children(true):
		if child is Block:
			var layer : int = __block_layer(child)
			child.move_in(-200.0 if layer > 0 else 200.0)
			child.z_index = layer + 1


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()


# Private variables

func __block_layer(block : Block) -> int:
	var coord : Vector2i = local_to_map(block.position)

	for layer : int in get_layers_count():
		if get_cell_source_id(layer, coord) != -1:
			return layer

	return -1
