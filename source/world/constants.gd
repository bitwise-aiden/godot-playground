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


static func world_to_coord(
	world : Vector2,
	y_value : int = 0
) -> Vector3i:
	var scaled : Vector2 = world / WorldConstants.HALF_BLOCK_SIZE

	var z : float = ((scaled.y + y_value) * 2.0 + scaled.x) * 0.5
	var x : float = z - scaled.x

	return Vector3i(int(x), y_value, int(z))
