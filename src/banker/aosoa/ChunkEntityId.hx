package banker.aosoa;

/**
	Composite value of Chunk ID and Entity ID.
**/
@:notNull
abstract ChunkEntityId(Int) {
	/**
		The identifier number of the Chunk to which the entity belongs.
	**/
	public var chunk(get, never): Int;

	/**
		The identifier number of the entity, which is unique in the Chunk.
	**/
	public var entity(get, never): Int;

	public function new(chunkId: Int, entityId: Int) {
		#if !macro
		assert(chunkId & 0xFFFF0000 == 0);
		assert(entityId & 0xFFFF0000 == 0);
		#end
		this = chunkId << 16 | entityId;
	}

	/**
		@return `Int` representation of `this`.
	**/
	public inline function toInt(): Int
		return this;

	inline function get_chunk() return this >>> 16;
	inline function get_entity() return this & 0xFFFF;
}
