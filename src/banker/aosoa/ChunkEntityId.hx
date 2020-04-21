package banker.aosoa;

/**
	Composite value of Chunk ID and Entity ID.
**/
@:notNull
@:access(sinker.UInt)
abstract ChunkEntityId(Int) {
	/**
		Dummy value of `ChunkEntityId`.
		Both Chunk ID and Entity ID are `65535`.
	**/
	public static extern inline final dummy: ChunkEntityId = cast 0xFFFFFFFF;

	/**
		Casts `Int` to `ChunkEntityId`.
	**/
	public static extern inline function fromInt(v: Int): ChunkEntityId
		return cast v;

	/**
		The identifier number of the Chunk to which the entity belongs.
	**/
	public var chunk(get, never): UInt;

	/**
		The identifier number of the entity, which is unique in the Chunk.
	**/
	public var entity(get, never): UInt;

	public extern inline function new(chunkId: UInt, entityId: UInt) {
		#if !macro
		assert(chunkId & 0xFFFF0000 == 0 && chunkId != 0xFFFF);
		assert(entityId & 0xFFFF0000 == 0 && entityId != 0xFFFF);
		#end
		this = chunkId << 16 | entityId;
	}

	/**
		@return `Int` representation of `this`.
	**/
	public extern inline function int(): Int
		return this;

	extern inline function get_chunk() {
		return new UInt(this >>> 16);
	}

	extern inline function get_entity() {
		return new UInt(this & 0xFFFF);
	}
}
