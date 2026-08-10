@tool
class_name Room
extends Node2D

## @class Room
## @desc This class is just to manage the scene and clone it

## @attr layers
## @desc layers of a room
var layers: Array[TileMapLayer]: 
	get: return [
		$LayerBottom,
		$LayerMiddle,
		$LayerTop
	]

## @attr entities
## @desc entities withing the room
var entities: Array[Entity]: 
	get: return get_node("Entities").get_children() as Array[Entity]

## @attr anchor_points
## @desc anchor_points withing the room
var anchor_points: Array[AnchorPoint]: 
	get: 
		var array: Array[AnchorPoint] = []
		for anchor_point in get_node("AnchorPoints").get_children():
			array.append(anchor_point as AnchorPoint)
		return array

## @attr tags
## @desc Tags of this room, is used on `Floor` to determine if this room should be generating in certain conditions
@export
var tags: Array[StringName]

## @func get_offset
## @desc offset to make the upper leftest tile coords match `Vector2i(0, 0)`
func get_offset() -> Vector2i:
	var offset: Vector2i = Vector2i(0, 0)
	for layer in layers:
		var rect: Rect2i = layer.get_used_rect()
		offset.x = min(offset.x, rect.position.x)
		offset.y = min(offset.y, rect.position.y)
	return offset

## @func get_used_tiles
## @ret Array[Vector3i] -> Vector3i(tile.x, tile.y, layer)
func get_used_tiles() -> Array[Vector3i]:
	var tiles: Array[Vector3i] = []
	for layer in range(layers.size()):
		for tile in layers[layer].get_used_cells():
			tiles.append(Vector3i(tile.x, tile.y, layer))
	return tiles


## @func save
## @desc automates saving this room into a .json file
func save() -> void:
	# Transform res://data/room/SCENES/this_scene.tscn -> res://data/room/METADATA/this_scene.json
	# TODO: Check if should keep here or as a function in `FilePaths`
	var scene_path: String = get_tree().edited_scene_root.scene_file_path.get_slice("scenes/", 1)
	var metadata_path: String = FilePaths.change_extension(scene_path, "tres")

	var data: RoomData = RoomData.new()
	data.path.scene = scene_path
	data.path.metadata = metadata_path
	data.tags = tags
	data.offset = get_offset()

	# ensure dir exists
	# TODO: Check if should keep here or as a function in `FilePaths`
	var base_dir: String = data.get_path_metadata().get_base_dir()
	if not DirAccess.dir_exists_absolute(base_dir):
		DirAccess.make_dir_recursive_absolute(base_dir)

	var size: Vector2i = Vector2i(0, 0)
	for layer in layers:
		var rect: Rect2i = layer.get_used_rect()
		size.x = max(size.x, rect.size.x)
		size.y = max(size.y, rect.size.y)
	data.size = size

	data.anchor_points = [ [], [], [], [] ]
	for anchor_point in get_node("AnchorPoints").get_children():
		# TODO: Refactor this, is shouldn't use $LayerMiddle as a default, try adding this when processing the layers, might need to add anchor points as children of layer
		var tile_position: Vector2i = layers[1].local_to_map(anchor_point.position)
		tile_position -= data.offset
		data.anchor_points[anchor_point.direction_towards_center].append(tile_position)

	var error: Error = ResourceSaver.save(data, data.get_path_metadata())
	if error:
		print("[Room] Error when saving data.")
	else:
		print("[Room] Updated metadata for %s" % data.get_path_scene())

func _notification(what: int) -> void:
	if Engine.is_editor_hint() and what == NOTIFICATION_EDITOR_PRE_SAVE:
		save()
