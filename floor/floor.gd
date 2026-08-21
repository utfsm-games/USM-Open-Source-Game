class_name Floor
extends Node2D

@onready
var layers: Array[TileMapLayer]:
	get: return [
		$LayerBottom,
		$LayerMiddle,
		$LayerTop,
	]

var room_manager: RoomManager = RoomManager.new()

## @attr max_branch_size
## @desc A branch in the floor can't exceed this amount of rooms
@export_range(1, 100, 1)
var max_branch_size: int = 5

## @attr used_cells
## @desc keeps a track of which positions are used by another cell, Dictionary for faster search times
var used_cells: Dictionary[Vector3i, bool] = {}

## @func is_cell_empty
## @ret `false` if `cell` is not present in `used_cells`, otherwise `true`
func is_cell_empty(cell: Vector3i) -> bool:
	return used_cells.get(cell, false)

## @func register_room_cells
## @desc adds a cell into `used_cells`
func register_room_cells(cells: Array[Vector3i]) -> void:
	for cell in cells:
		used_cells[cell] = true

## @func can_put_room
## @not_ready
## @desc verifies `new_room.size` can fit on the `Floor`
# TODO: Finish this function
func can_put_room(new_room_data: RoomData, upper_left_corner: Vector2i) -> bool:
	var room_size: Vector2i = new_room_data.size
	for y in range(upper_left_corner.y, upper_left_corner.y + room_size.y):
		for x in range(upper_left_corner.x, upper_left_corner.x + room_size.x):
			if used_cells.has(Vector3i(x, y, 0)): return false
			if used_cells.has(Vector3i(x, y, 1)): return false
			if used_cells.has(Vector3i(x, y, 2)): return false
	return true

## @func put_room
## @param upper_left_corner Tile coords of the upper corner of the new room
## @desc pastes the tiles of `new_room` into the floor's `TileMapLayer`, and deletes the original layers off `new_room`
func put_room(new_room: Room, upper_left_corner: Vector2i) -> void:
	# Copy tiles
	# TODO: Should refactor this to make them have as many layers as `new_room` has
	var tiles: Array[Vector3i] = new_room.get_used_tiles()
	var new_room_layers: Array[TileMapLayer] = [new_room.layers[0], new_room.layers[1], new_room.layers[2]]
	var tile_offset: Vector2i = new_room.get_offset()
	for tile in tiles:
		var coords: Vector2i = Vector2i(tile.x, tile.y)
		var layer: TileMapLayer = layers[tile.z]
		var new_room_layer: TileMapLayer = new_room_layers[tile.z]
		# FIXME
		if new_room_layer.tile_set != layer.tile_set:
			printerr("[Floor] Still figuring out how to keep multiple tile_sets on the same floor layer")
			return
		var source_id: int = new_room_layer.get_cell_source_id(coords)
		var atlas_coords: Vector2i = new_room_layer.get_cell_atlas_coords(coords)
		var alternative_tile: int = new_room_layer.get_cell_alternative_tile(coords)
		var new_coords = coords - tile_offset + upper_left_corner
		layer.set_cell(new_coords, source_id, atlas_coords, alternative_tile)
		used_cells[Vector3i(new_coords.x, new_coords.y, tile.z)] = true
	for layer in new_room_layers:
		layer.queue_free()
	
	# Offset the rest of nodes
	# TODO: Shouldn't be $LayerMiddle
	var local_offset: Vector2 = (upper_left_corner - tile_offset) * layers[1].tile_set.tile_size

	for anchor_point in new_room.anchor_points:
		anchor_point.position += local_offset
	for entity in new_room.entities:
		entity.position += local_offset
	
	add_child(new_room)

## @func generate_spawn
## @desc Initial stage of `Floor` generation
func generate_spawn() -> Room:
	var files: PackedStringArray = room_manager.tag_to_room_files["spawn"]
	var file: String = files.get(randi() % files.size())
	var room: Room = RoomData.load_from(file)
	put_room(room, Vector2i(0, 0))
	return room

## @func generate_branch
## @desc goes to an `AnchorPoint` and starts generating `Room`s, unless the step exceeds `max_branch_size`
func generate_branch(previous_anchor_point: AnchorPoint, step: int) -> void:
	if step >= max_branch_size: return
	if previous_anchor_point.desired_tags.size() == 0: return

	var next_direction: Direction.Type = previous_anchor_point.get_outwards_direction()
	var room_data: RoomData = room_manager.get_rooms_pointing(previous_anchor_point.select_tag(), previous_anchor_point.get_outwards_direction()).pick_random()

	# No suitable room
	if room_data == null: return

	# Get upper left corner
	# TODO: should refactor `AnchorPoint` to MAYBE make then a tile instead of a `Marker2D`, should in theory be easier than transforming local_to_map
	# Picks a random `AnchorPoint`'s position that is pointing to `next_direction`
	var next_anchor_point_local_position: Vector2i = room_data.anchor_points[next_direction].pick_random()
	# Tile position of the next `AnchorPoint`
	var connection_position: Vector2i = layers[1].local_to_map(previous_anchor_point.position) + Direction.as_vector(next_direction)
	# When substracting `next_anchor_point_local_position` we get `upper_left_corner`
	var upper_left_corner: Vector2i = connection_position - next_anchor_point_local_position

	# FIXME make sure anchor_points are not repeated
	if can_put_room(room_data, upper_left_corner):
		var room: Room = room_data.load()
		put_room(room, upper_left_corner)
		for anchor_point in room.anchor_points:
			generate_branch(anchor_point, step + 1)

## @func generate_floor
## @desc main function for `Floor` generation
func generate_floor() -> void:
	var spawn_room: Room = generate_spawn()
	var anchor_points: Array[AnchorPoint] = spawn_room.anchor_points
	anchor_points.shuffle()
	for anchor_point in anchor_points:
		generate_branch(anchor_point, 0)

func _ready() -> void:
	generate_floor()
