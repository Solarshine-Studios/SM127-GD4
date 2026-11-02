class_name LayerData
extends LevelDataResource

var layer_header: LayerHeader
var tile_container: TileContainer
var object_data: Array[ObjectData]

# Called when the node enters the scene tree for the first time.
func _init(set_layer_header: LayerHeader, set_tile_container: TileContainer, set_object_data: Array[ObjectData] = []) -> void:
	layer_header = set_layer_header
	object_data = set_object_data
	tile_container = set_tile_container

static func duplicate_header(other: LayerHeader) -> LayerHeader:
	return LayerHeader.new(
		other.parallax_distance,
		other.parallax_offset,
		other.autoset_tint,
		other.tint_as_fog,
		other.layer_tint,
		other.order,
		other.is_ground,
		other.layer_name,
		other.is_origin,
		other.activated_mission_ids,
		other.disabled,
		other.layer_opacity,
		other.lock_axis,
		other.min_shines,
		other.max_shines,
		other.layer_uuid
	)

func place_tile(coords: Vector2, tileset: int, type: int, palette: int = 0) -> void:
	tile_container.set_tile(coords, tileset, type, palette)

func erase_tile(coords: Vector2) -> void:
	tile_container.erase_tile(coords)

func add_object(data: ObjectData) -> void:
	object_data.append(data)

func erase_object(data: ObjectData) -> void:
	object_data.erase(data)

func place_object(position: Vector2, data: ObjectData) -> void:
	data.header.position = position
	add_object(data)

func can_spawn_layer(save_data: LevelSaveData, selected_mission_id: String) -> bool:
	if layer_header.min_shines > -1:
		if save_data._completed_missions.size() < layer_header.min_shines:
			return false
	if layer_header.max_shines > -1:
		if save_data._completed_missions.size() > layer_header.max_shines:
			return false
	if not layer_header.activated_mission_ids.is_empty():
		return selected_mission_id in layer_header.activated_mission_ids
	return true

static func tiles_to_tile_container(tiles: Dictionary, chunks: Dictionary) -> TileContainer:
	var tile_container: TileContainer = TileContainer.new()
	for position in tiles:
		var chunk_pos: Vector2i = tile_container.get_chunk_coords(position)
		
		if not tile_container.chunks.has(chunk_pos):
			var chunk: PackedInt32Array = PackedInt32Array()
			chunk.resize(TileContainer.TILE_CHUNK_SIZE * TileContainer.TILE_CHUNK_SIZE)
			chunk.fill(0)
			tile_container.set_chunk_data(chunk_pos, chunk)
			
		tile_container.set_tile(position, tiles[position][0], tiles[position][1], tiles[position][2])
	return tile_container
