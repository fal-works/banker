package banker.types;

import banker.types.internal.BytesData;

/**
	Bytes with fast (but unsafe) data access.
**/
@:notNull @:forward(toHex, toString)
abstract Bytes(haxe.io.Bytes) from haxe.io.Bytes to haxe.io.Bytes {
	/**
		Creates a `Bytes` instance.
	**/
	public static extern inline function alloc(length: UInt): Bytes
		return haxe.io.Bytes.alloc(length);

	/**
		Blits bytes data from `src` to `dest`.
	**/
	public static extern inline function blit(
		src: Bytes,
		srcPos: UInt,
		dest: Bytes,
		destPos: UInt,
		length: UInt
	): Void {
		dest.data.internal.blit(destPos, src.data.internal, srcPos, length);
	}

	/**
		The length of `this` bytes.
	**/
	public var length(get, never): UInt;

	/**
		The data of `this` that provides read/write access.
	**/
	public var data(get, never): BytesData;

	/**
		Sets `length` bytes from `startPos` of `this` instance to `value`.
	**/
	public extern inline function fillIn(
		startPos: UInt,
		length: UInt,
		value: Int
	): Void
		this.fill(startPos, length, value);

	/**
		Sets all bytes to `value`.
	**/
	public extern inline function fill(value: Int): Void
		fillIn(UInt.zero, this.length, value);

	/**
		Sets all bytes to zero.
	**/
	public extern inline function clear(): Void
		fill(0);

	/**
		@return New `Bytes` instance with values copied from `this`.
	**/
	public extern inline function sub(startPos: UInt, length: UInt): Bytes
		return this.sub(startPos, length);

	extern inline function get_length(): UInt
		return this.length;

	@:access(haxe.io.Bytes)
	extern inline function get_data() {
		#if hl
		return this.b;
		#else
		return this;
		#end
	}
}
