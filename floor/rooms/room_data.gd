class_name RoomData
extends Resource

## @attr path filepaths of this room
@export
var path: Dictionary = {
	"scene" = null,
	"metadata" = null,
}

## @attr anchor_points positions relative to this room with offset applied, technically a Dictionary[Direction, Array[Vector2i]]
@export
var anchor_points: Array = [[], [], [], []]

## @attr offset Offset of the tiles to make them start at (0, 0)
@export
var offset: Vector2i = Vector2i.ZERO

## @attr size Size of this room, contains the biggest values of size of all rooms overall
@export
var size: Vector2i = Vector2i.ZERO

## @attr tags The tags of this room, do not confuse them with the `AnchorPoint.tags`
@export
var tags: PackedStringArray = []

## @func load
## @desc executes load on a valid relative path .tres RoomData file
static func load_from(relative_path: String) -> Room:
	var data: RoomData = load(FilePaths.room.metadata + relative_path) as RoomData
	return load(data.get_path_scene()).instantiate() as Room
func load() -> Room:
	return load(get_path_scene()).instantiate() as Room

func string() -> String:
	return "scene_path: %s,metadata_path: %s,anchor_points: %s,offset: %s,size: %s,tags: %s" % [path.scene, path.metadata, anchor_points, offset, size, tags]

func get_path_scene() -> String:
	return FilePaths.room.scenes + path.scene

func get_path_metadata() -> String:
	return FilePaths.room.metadata + path.metadata
