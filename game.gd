class_name Game extends Node3D


# Private constants

const __BLOCK : PackedScene = preload("res://block.tscn")


# Private variables

@onready var __camera : Camera3D = $camera


# Lifecycle methods

func _ready() -> void:
	__camera.look_at(Vector3.ZERO)

	for x in 5:
		for y in 5:
			for z in 5:
				if x == 0 || y == 0 || z == 0:
					var block : Block = __BLOCK.instantiate()
					add_child(block)

					block.position = Vector3(x, y, z) * .2 # Vector3(0.225, 0.19, 0.225)
					print(block.position)
