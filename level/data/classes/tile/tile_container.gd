class_name TileContainer
extends Resource

### Resource that stores tiles for any object 
### to use and store in a level code.

const TILE_CHUNK_SIZE: int = 16

## Dictionary of Vector2si and PoolIntArrays
var chunks: Dictionary[Vector2i, PackedInt64Array] = {}
var used_tiles: PackedVector2Array = PackedVector2Array()

func _init() -> void:
	chunks = {}
	used_tiles = PackedVector2Array()

static func get_chunk_coords(coords: Vector2i) -> Vector2i:
	return (Vector2(coords) / TILE_CHUNK_SIZE).floor()

func set_tile(coords: Vector2i, tileset: int, type: int, palette: int) -> void:
	# if any of these are below 0, then the tile is being erased
	if tileset <= 0 or type < 0 or palette < 0:
		tileset = 0
		type = 0
		palette = 0
		
		while used_tiles.has(coords):
			used_tiles.remove_at(used_tiles.find(coords))
	else:
		if not used_tiles.has(coords):
			used_tiles.append(coords)
	
	coords = coords.snapped(Vector2i.ONE)
	var chunk_coords: Vector2i = get_chunk_coords(coords)
	var chunk: PackedInt64Array = chunks.get_or_add(chunk_coords, PackedInt64Array())
	if chunk.is_empty():
		chunk.resize(TILE_CHUNK_SIZE * TILE_CHUNK_SIZE)
		chunk.fill(0)
	
	@warning_ignore("narrowing_conversion")
	var tile_index: int = int(posmod(coords.x, TILE_CHUNK_SIZE) + posmod(coords.y, TILE_CHUNK_SIZE) * TILE_CHUNK_SIZE)
	chunk[tile_index] = TileHelper.get_packed_tile(tileset, type, palette)
	
	chunks[chunk_coords] = chunk

func erase_tile(coords: Vector2i) -> void:
	set_tile(coords, -1, -1, -1)

func set_chunk_data(chunk_coords: Vector2i, chunk_data: PackedInt64Array) -> void:
	if chunk_data.count(0) >= TileHelper.TILE_CHUNK_SIZE * TileHelper.TILE_CHUNK_SIZE:
		return
	
	if chunks.has(chunk_coords):
		chunks[chunk_coords] = chunk_data
	else:
		chunks.get_or_add(chunk_coords, chunk_data)
	
	for x in range(TILE_CHUNK_SIZE):
		for y in range(TILE_CHUNK_SIZE):
			if chunk_data[x + y * TILE_CHUNK_SIZE] > 0:
				used_tiles.append(chunk_coords * 16 + Vector2i(x, y))

func get_packed_tile_at(coords: Vector2i) -> int:
	var chunk_coords: Vector2i = get_chunk_coords(coords)
	var chunk: PackedInt32Array = chunks.get(chunk_coords, PackedInt32Array())
	if chunk.is_empty():
		chunk.resize(TILE_CHUNK_SIZE * TILE_CHUNK_SIZE)
		chunk.fill(0)
	
	var tile_index: int = int(posmod(coords.x, TILE_CHUNK_SIZE) + posmod(coords.y, TILE_CHUNK_SIZE) * TILE_CHUNK_SIZE)
	return chunk[tile_index]

func get_tile_set_id_at(coords: Vector2i) -> int:
	return TileHelper.get_tile_set_id_from_packed(get_packed_tile_at(coords))

func get_tile_id_at(coords: Vector2i) -> int:
	return TileHelper.get_tile_id_from_packed(get_packed_tile_at(coords))

func get_palette_id_at(coords: Vector2i) -> int:
	return TileHelper.get_palette_id_from_packed(get_packed_tile_at(coords))

func get_tile_data_at(coords: Vector2i) -> Array:
	return [get_tile_set_id_at(coords), get_tile_id_at(coords), get_palette_id_at(coords)]

func get_tile_data_from_packed(packed_data: int) -> Array:
	return [TileHelper.get_tile_set_id_from_packed(packed_data), TileHelper.get_tile_id_from_packed(packed_data), TileHelper.get_palette_id_from_packed(packed_data)]
