class_name WorldBlock extends Node2D


# Public variables

var coord : Vector3i :
	set(value):
		coord = value

		__coord_position = Vector2(
			value.z - value.x,
			(value.z + value.x) * 0.5 - value.y,
		) * WorldConstants.HALF_BLOCK_SIZE

		__update_position()

		z_index = value.y

		if is_node_ready():
			__update_sprite()


var data : DataBlock = preload("res://source/data/blocks/block_missing.tres") :
	set(value):
		data = value

		if is_node_ready():
			__update_sprite()


var offset : Vector2 = Vector2.ZERO :
	set(value):
		offset = value

		__update_position()


# Private variables

@onready var __sprite : Sprite2D = $sprite

var __coord_position : Vector2


# Lifecycle methods

func _ready() -> void:
	__update_sprite()


# Private methods

func __update_position() -> void:
	position = __coord_position + offset


func __update_sprite() -> void:
	__sprite.texture = data.get_texture_for_coord(coord)
