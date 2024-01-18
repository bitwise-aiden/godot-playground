class_name WorldConstants extends RefCounted


# Public constants

const BLOCK_SIZE : int = 64
const HALF_BLOCK_SIZE : int = int(BLOCK_SIZE / 2.0)


# Public methods

static func coord_to_world(
	coord : Vector3i,
) -> Vector2:
	return Vector2(
		coord.z - coord.x,
		(coord.z + coord.x) * 0.5 - coord.y,
	) * WorldConstants.HALF_BLOCK_SIZE
