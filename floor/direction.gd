class_name Direction

## @class enum Direction
## @desc Directions an `AnchorPoint` can face to (inwards)

## @enum Type
## @desc all 4 directions a `Room` can point to
enum Type {
	UP,
	RIGHT,
	DOWN,
	LEFT,
	NULL
}

## @alias Type
const UP: Type = Type.UP
const RIGHT: Type = Type.RIGHT
const DOWN: Type = Type.DOWN
const LEFT: Type = Type.LEFT
const NULL: Type = Type.NULL

## @func static opposite
## @ret inverts `direction`
static func opposite(direction: Direction.Type) -> Direction.Type:
	match direction:
		Direction.UP:		return Direction.DOWN
		Direction.RIGHT:	return Direction.LEFT
		Direction.DOWN:		return Direction.UP
		Direction.LEFT:		return Direction.RIGHT
	return Direction.NULL

## @func static as_vector
## @ret the Vector2i equivalent of `direction`
static func as_vector(direction: Direction.Type) -> Vector2i:
	match direction:
		Direction.UP:		return Vector2i.UP
		Direction.RIGHT:	return Vector2i.RIGHT
		Direction.DOWN:		return Vector2i.DOWN
		Direction.LEFT:		return Vector2i.LEFT
	return Vector2i.ZERO
