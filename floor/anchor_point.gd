class_name AnchorPoint
extends Marker2D

## @class AnchorPoint
## @desc Point of a `Room` that connects to the next one

## @attr direction_towards_center
## @desc Indicates which axis it should put a tile to make an entrance
@export
var direction_towards_center: Direction.Type = Direction.UP

## @attr desired_tags
## @desc used during `Floor` generation to tell the `RoomManager` which `Rooms` it should generate connected to this door
@export
var desired_tags: Array[StringName] = ["default"]

# TODO: Make `entrance_size` to make multi tile entrances
