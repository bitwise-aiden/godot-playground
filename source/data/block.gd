class_name DataBlock extends Resource


# Public variables

@export var textures : Array[Texture2D]


# Public methods

func get_texture_for_coord(
	coord : Vector3i,
) -> Texture2D:
	var index : int = rand_from_seed(hash(coord))[0] % textures.size()

	return textures[index]
