class_name RoomManager
extends RefCounted

## @class RoomManager
## @desc Manages a collection of rooms for the `Floor`

## @attr tag_to_room_files
## @desc Holds the relations between tags and rooms
var tag_to_room_files: Dictionary[StringName, PackedStringArray] = {"default": []}

## @func get_tags
## @desc Reads the `FilePaths.room.tag` json and returns it's values
func get_tags() -> Array[StringName]:
	var tags: Array[StringName] = []
	var json: Dictionary = FilePaths.read_json(FilePaths.room.tag)
	# `values` is an array in FilePaths.room.tag
	for tag in json.values:
		tags.append(tag)
	return tags

## @func get_rooms_pointing
## @desc Filter rooms of certain `tag` that have `Anchor Points` pointing towards `direction`
func get_rooms_pointing(tag: StringName, direction: Direction.Type) -> Array[RoomData]:
	var scenes: Array[RoomData] = []
	for file in tag_to_room_files[tag]:
		var room: RoomData = load(FilePaths.room.metadata + file)
		if room.anchor_points[direction].size() > 0:
			scenes.append(room)
	return scenes


# TODO: `RoomManager` should not handle this or maybe should have a function
func _init() -> void:
	# TODO: Should probably refactor ts so it adds the tags to the dictionary so is faster
	# Here we make sure every tag was defined and also it prevent typos
	var tags: Array[StringName] = get_tags()
	var room_files: PackedStringArray = FilePaths.get_all_rooms()
	for file in room_files:
		var room: RoomData = load(FilePaths.room.metadata + file)
		for tag in room.tags:
			# Makes sure the tag exists
			# TODO: Should probably refactor ts so it adds the tags to the dictionary so is faster
			if not tags.has(tag):
				printerr("[RoomManager] TAG \"%s\" UNDER \"%s\" IS NOT REGISTERED" % [tag, file])
				return
			# TODO: Makes sure the `Room` scene exists (Prolly we should not, considering the to do from below)
			if not tag_to_room_files.has(tag):
				tag_to_room_files[tag] = []
			tag_to_room_files[tag].append(file)
