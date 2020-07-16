package banker.binary.internal;

import hl.Bytes as InternalData;

/**
	The data of `Bytes`.
**/
@:notNull
abstract BytesData(InternalData) from InternalData {
	/**
		The internal representation of `this`.
	**/
	public var internal(get, never): InternalData;

	public extern inline function setInt32(pos: UInt, v: Int): Void
		this.setI32(pos, v);

	public extern inline function setFloat64(pos: UInt, v: Float): Void
		this.setF64(pos, v);

	public extern inline function getInt32(pos: UInt): Int
		return this.getI32(pos);

	public extern inline function getFloat64(pos: UInt): Float
		return this.getF64(pos);

	extern inline function get_internal()
		return this;
}
