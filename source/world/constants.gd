class_name WorldConstants extends RefCounted


# Public constants

const BLOCK_SIZE : int = 64
const HALF_BLOCK_SIZE : int = int(BLOCK_SIZE / 2.0)

# Generated from: `WorldConstants.coord_to_world(Vector3i.BACK).normalized()`
const BLOCK_POSITION_SCALAR : Vector2 = Vector2(0.894427, 0.447214)

const PLAYER_SPEED : float = 200.0


# Public methods

static func coord_to_world(
	coord : Vector3i,
) -> Vector2:
	return Vector2(
		coord.z - coord.x,
		(coord.z + coord.x) * 0.5 - coord.y,
	) * WorldConstants.HALF_BLOCK_SIZE
