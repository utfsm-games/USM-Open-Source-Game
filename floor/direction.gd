class_name Direction

## @enum Direction
## @desc all 4 directions a `Room` can point to
enum Type {
	UP,
	RIGHT,
	DOWN,
	LEFT,
	NULL
}

## @alias Direction.UP
const UP: Type = Type.UP
const RIGHT: Type = Type.RIGHT
const DOWN: Type = Type.DOWN
const LEFT: Type = Type.LEFT
const NULL: Type = Type.NULL

static func opposite(direction: Direction.Type) -> Direction.Type:
	match direction:
		Direction.UP:		return Direction.DOWN
		Direction.RIGHT:	return Direction.LEFT
		Direction.DOWN:		return Direction.UP
		Direction.LEFT:		return Direction.RIGHT
	return Direction.NULL

static func as_vector(direction: Direction.Type) -> Vector2i:
	match direction:
		Direction.UP:		return Vector2i.UP
		Direction.RIGHT:	return Vector2i.RIGHT
		Direction.DOWN:		return Vector2i.DOWN
		Direction.LEFT:		return Vector2i.LEFT
	return Vector2i.ZERO
