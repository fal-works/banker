package banker.aosoa;

/**
	Composite value of Chunk ID and Entity ID.
**/
@:notNull
abstract ChunkEntityId(Int) {
	/**
		Dummy value of `ChunkEntityId`.
		Both Chunk ID and Entity ID are `65535`.
	**/
	public static final dummy: ChunkEntityId = cast 0xFFFFFFFF;

	/**
		Casts `Int` to `ChunkEntityId`.
	**/
	public static inline function fromInt(v: Int): ChunkEntityId
		return cast v;

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
		assert(chunkId & 0xFFFF0000 == 0 && chunkId != 0xFFFF);
		assert(entityId & 0xFFFF0000 == 0 && entityId != 0xFFFF);
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
