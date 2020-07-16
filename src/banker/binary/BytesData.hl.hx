package banker.binary;

import hl.Bytes as InternalData;
import banker.binary.internal.Constants.LEN32;

/**
	The data of `Bytes`.
**/
@:notNull
abstract BytesData(InternalData) from InternalData {
	/**
		Creates a `BytesData` instance.
		@param length Length in bytes to be allocated.
	**/
	public static extern inline function alloc(length: UInt)
		return new InternalData(length);

	/**
		The internal representation of `this`.
	**/
	public var internal(get, never): InternalData;

	public extern inline function setI32(pos: UInt, v: Int32): Void
		this.setI32(pos, v);

	public extern inline function setI64(pos: UInt, v: Int64): Void {
		setI32(pos + LEN32, v.high);
		setI32(pos, v.low);
	}

	public extern inline function setF32(pos: UInt, v: Float32): Void
		this.setF32(pos, v);

	public extern inline function setF64(pos: UInt, v: Float): Void
		this.setF64(pos, v);

	public extern inline function getI32(pos: UInt): Int32
		return this.getI32(pos);

	public extern inline function getI64(pos: UInt): Int64
		return Int64.make(getI32(pos + LEN32), getI32(pos));

	public extern inline function getF32(pos: UInt): Float32
		return this.getF32(pos);

	public extern inline function getF64(pos: UInt): Float
		return this.getF64(pos);

	extern inline function get_internal()
		return this;
}
