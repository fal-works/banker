package banker.binary.internal;

import haxe.Int32;
import haxe.Int64;
import haxe.io.Bytes as InternalData;

/**
	The data of `Bytes`.
**/
@:notNull
abstract BytesData(InternalData) from InternalData {
	/**
		The internal representation of `this`.
	**/
	public var internal(get, never): InternalData;

	public extern inline function setI32(pos: UInt, v: Int32): Void
		this.setInt32(pos, v);

	public extern inline function setI64(pos: UInt, v: Int64): Void
		this.setInt64(pos, v);

	public extern inline function setF32(pos: UInt, v: Float32): Void
		this.setFloat(pos, v);

	public extern inline function setF64(pos: UInt, v: Float): Void
		this.setDouble(pos, v);

	public extern inline function getI32(pos: UInt): Int32
		return this.getInt32(pos);

	public extern inline function getI64(pos: UInt): Int64
		return this.getInt64(pos);

	public extern inline function getF32(pos: UInt): Float32
		return this.getFloat(pos);

	public extern inline function getF64(pos: UInt): Float
		return this.getDouble(pos);

	extern inline function new(internal: InternalData)
		this = internal;

	extern inline function get_internal()
		return this;
}
