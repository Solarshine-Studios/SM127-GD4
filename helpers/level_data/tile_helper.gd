class_name TileHelper
extends Object


# Yummy bitpacking my favorite
# I mean this is used to pack tile data more efficiently in memory, as well as
# converting from 127's tile set ids to Godot's tile set IDs.


const TILE_CHUNK_SIZE: int = 16
const BYTES_PER_TILE: int = 3
const CHUNK_HEADER_SIZE: int = 6
# bounds size is 2^16 + 1 due to the right and bottom edges being exclusive
const CHUNK_COORD_BOUNDS: Rect2 = Rect2(-32767, -32767, 65537, 65537) 
static var TILE_IDS: Array = preload("res://generation/tileset_ids.res").tileset_ids


static func get_packed_tile(tile_set: int, tile: int, palette: int) -> int:
	return tile_set | (tile << 8) | (palette << 16)


static func get_tile_set_id_from_packed(value: int) -> int:
	return value & 0x000000FF


static func get_tile_id_from_packed(value: int) -> int:
	return (value & 0x0000FF00) >> 8


static func get_palette_id_from_packed(value: int) -> int:
	return (value & 0x00FF0000) >> 16


static func get_real_tile_set_id_from_packed(value: int) -> int:
	return get_real_tile_set_id(
		get_tile_set_id_from_packed(value), 
		get_tile_id_from_packed(value), 
		get_palette_id_from_packed(value)
	)


static func get_real_tile_set_id(tileset_id: int, tile_id: int, palette_id: int = 0) -> int:
	if TILE_IDS[tileset_id].size() < palette_id:
		palette_id = 0
	
	return TILE_IDS[tileset_id][palette_id][tile_id]


# Takes a chunk dictionary and used tiles list from TileData
static func chunks_to_tile_bytes(tile_chunks: Dictionary) -> PackedByteArray:
	var tile_bytes: PackedByteArray = PackedByteArray()
	
	for chunk_coord: Vector2 in tile_chunks:
		if not CHUNK_COORD_BOUNDS.has_point(chunk_coord):
			# if the chunk isn't in at a in-bounds coord we just skip it
			# that really shouldn't happen but it's a safety measure you know?
			continue
		
		tile_bytes.append(int(chunk_coord.abs().x))
		if chunk_coord.sign().x >= 0:
			tile_bytes.append(int(chunk_coord.abs().x) >> 8)
		else:
			tile_bytes.append((int(chunk_coord.abs().x) >> 8) | 0b10000000)
		
		tile_bytes.append(int(chunk_coord.abs().y))
		if chunk_coord.sign().y >= 0:
			tile_bytes.append(int(chunk_coord.abs().y) >> 8)
		else:
			tile_bytes.append((int(chunk_coord.abs().y) >> 8) | 0b10000000)
		
		var chunk_buffer: PackedByteArray = PackedByteArray()
		for tile: int in tile_chunks[chunk_coord]:
			chunk_buffer.append(get_tile_set_id_from_packed(tile))
			chunk_buffer.append(get_tile_id_from_packed(tile))
			chunk_buffer.append(get_palette_id_from_packed(tile))
		
		chunk_buffer = chunk_buffer.compress(FileAccess.COMPRESSION_DEFLATE)
		tile_bytes.append(chunk_buffer.size())
		tile_bytes.append(chunk_buffer.size() >> 8)
		tile_bytes.append_array(chunk_buffer)
	
	return tile_bytes


# Returns a chunk dictionary for TileData
static func tile_bytes_to_chunks(tile_bytes: PackedByteArray) -> Dictionary:
	var chunks: Dictionary = {}
	
	# if the bytes array is too small we obviously can't do anything so just
	# return the empty dictionary
	if tile_bytes.size() < CHUNK_HEADER_SIZE + TILE_CHUNK_SIZE:
		return chunks
	
	var chunk_start: int = 0
	var chunk_coords: Vector2 = Vector2.ZERO
	var chunk_size: int = 768
	var chunk_buffer: PackedByteArray = PackedByteArray()
	while (chunk_start < tile_bytes.size()):
		if tile_bytes[chunk_start + 1] & 0b10000000 == 0: # positive chunk coord
			chunk_coords.x = int(tile_bytes[chunk_start] | (tile_bytes[chunk_start + 1] << 8))
		else: # negative chunk coord
			var high: int = tile_bytes[chunk_start + 1] & 0b01111111
			chunk_coords.x = -int(tile_bytes[chunk_start] | (high << 8))
		
		if tile_bytes[chunk_start + 3] & 0b10000000 == 0: # positive chunk coord
			chunk_coords.y = int(tile_bytes[chunk_start + 2] | (tile_bytes[chunk_start + 3] << 8))
		else: # negative chunk coord
			var high: int = tile_bytes[chunk_start + 3] & 0b01111111
			chunk_coords.y = -int(tile_bytes[chunk_start + 2] | (high << 8))
		
		chunk_size = tile_bytes[chunk_start + 4] | (tile_bytes[chunk_start + 5] << 8)
		# subtracting 1 is needed due to PoolByteArray.subarray() having both the start and end inclusive
		chunk_buffer = tile_bytes.slice(chunk_start + CHUNK_HEADER_SIZE, chunk_start + CHUNK_HEADER_SIZE + chunk_size)
		chunk_buffer = chunk_buffer.decompress(TILE_CHUNK_SIZE * TILE_CHUNK_SIZE * BYTES_PER_TILE, FileAccess.COMPRESSION_DEFLATE)
		
		var chunk: PackedInt32Array = chunks.get_or_add(chunk_coords, PackedInt32Array()) as PackedInt32Array
		if chunk.is_empty():
			chunk.resize(TILE_CHUNK_SIZE * TILE_CHUNK_SIZE)
			chunk.fill(0)
		
		for i in range(0, chunk_buffer.size(), BYTES_PER_TILE):
			chunk[i / BYTES_PER_TILE] = get_packed_tile(chunk_buffer[i], chunk_buffer[i + 1], chunk_buffer[i + 2])
		
		chunks[chunk_coords] = chunk
		
		chunk_start += CHUNK_HEADER_SIZE + chunk_size
	
	return chunks


static func get_placeable_from_tile(tile_data: Array, placeable_items: Object) -> Object:
	for item: Object in placeable_items.placeable_items.values():
		if item is PlaceableObject: continue
		if item.tileset_id == tile_data[0] and item.tile_id == tile_data[1]:
			return item
	return null
