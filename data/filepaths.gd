class_name FilePaths

## @class helper FilePaths
## @desc helps with file paths operations

const room: Dictionary = {
	"tag": "res://data/rooms/tags.json",
	"scenes": "res://data/rooms/scenes/",
	"metadata": "res://data/rooms/metadata/"
}

## @func read_json
## @desc reads a json file and prints an error if doesn't exists / cannot parse
## @arg filepath must be an absolute path
static func read_json(filepath: String) -> Dictionary:
	if not FileAccess.file_exists(filepath):
		printerr("[FilePath] JSON FILE %s DOES NOT EXISTS!" % filepath)
		return {}

	var json: JSON = JSON.new()
	var file_access: FileAccess = FileAccess.open(filepath, FileAccess.READ_WRITE)
	if json.parse(file_access.get_as_text()) != OK:
		printerr("[FilePath] CANNOT PARSE JSON FILE %s!" % filepath)
		return {}

	return json.data

## @func get_all_rooms
## @ret `PackedStringArray` with each room as an absolute path
static func get_all_rooms() -> PackedStringArray:
	var files: PackedStringArray = []
	for dir in DirAccess.get_directories_at(room.metadata):
		# TODO: This should recursively explore the files
		for file in DirAccess.get_files_at("%s/%s" % [room.metadata, dir]):
			files.append("%s/%s" % [dir, file])
	return files

## @func without_extension
## @ret Copy of `file` without the extension
static func remove_extension(file: String) -> String:
	return file.trim_suffix("." + file.get_extension())

## @func change_extension
## @ret Copy of `file` with the `new_extension`
static func change_extension(file: String, new_extension: String) -> String:
	return "%s.%s" % [remove_extension(file), new_extension]
