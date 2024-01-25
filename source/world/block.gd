class_name WorldBlock extends Node2D

# Public enums

enum Collider { None = 0 << 0, Bottom = 1 << 0, Top = 1 << 1 }


# Public variables

var collider : Collider :
	set(value):
		collider = value

		if is_node_ready():
			__update_collider()


var coord : Vector3i :
	set(value):
		coord = value

		__coord_position = WorldConstants.coord_to_world(coord)

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
@onready var __collider_bottom : CollisionPolygon2D = $collider_bottom
@onready var __collider_top : CollisionPolygon2D = $collider_top

var __coord_position : Vector2


# Lifecycle methods

func _ready() -> void:
	__update_collider()
	__update_sprite()


# Public methods

func transition(
	to : Vector2,
	tween : Tween = create_tween()
) -> void:
	tween.tween_property(
		self,
		"offset",
		to,
		0.2 + randf() * 0.3
	)


# Private methods

func __update_collider() -> void:
	__collider_bottom.disabled = !collider & Collider.Bottom
	__collider_top.disabled = !collider & Collider.Top


func __update_position() -> void:
	position = __coord_position + offset


func __update_sprite() -> void:
	__sprite.texture = data.get_texture_for_coord(coord)
