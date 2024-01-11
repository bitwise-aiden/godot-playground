class_name WorldBlock extends Node2D


# Public variables

var coord : Vector3i :
	set(value):
		coord = value

		if is_node_ready():
			__update_sprite()


var data : DataBlock = preload("res://source/data/blocks/block_missing.tres") :
	set(value):
		data = value

		if is_node_ready():
			__update_sprite()


# Private variables

@onready var __sprite : Sprite2D = $sprite


# Lifecycle methods

func _ready() -> void:
	__update_sprite()


# Private methods

func __update_sprite() -> void:
	__sprite.texture = data.get_texture_for_coord(coord)
