package banker.binary;

import haxe.io.Bytes as InternalData;
import sneaker.string_buffer.StringBuffer;
import banker.vector.Vector;

/**
	The data of `Bytes`.
**/
@:notNull
abstract BytesData(InternalData) from InternalData {
	static var hexChars = {
		Vector.fromArrayCopy("0123456789abcdef".split("").map(s -> s.firstCharCode()));
	};

	/**
		Creates a `BytesData` instance.
		@param length Length in bytes to be allocated.
	**/
	public static extern inline function alloc(length: UInt)
		return InternalData.alloc(length);

	/**
		The internal representation of `this`.
	**/
	public var internal(get, never): InternalData;

	public extern inline function setUI8(pos: UInt, v: UInt8): Void
		this.set(pos, v);

	public extern inline function setI32(pos: UInt, v: Int32): Void
		this.setInt32(pos, v);

	public extern inline function setI64(pos: UInt, v: Int64): Void
		this.setInt64(pos, v);

	public extern inline function setF32(pos: UInt, v: Float32): Void
		this.setFloat(pos, v);

	public extern inline function setF64(pos: UInt, v: Float): Void
		this.setDouble(pos, v);

	public extern inline function getUI8(pos: UInt): UInt8
		return UInt8.fromIntUnsafe(this.get(pos));

	public extern inline function getI32(pos: UInt): Int32
		return this.getInt32(pos);

	public extern inline function getI64(pos: UInt): Int64
		return this.getInt64(pos);

	public extern inline function getF32(pos: UInt): Float32
		return this.getFloat(pos);

	public extern inline function getF64(pos: UInt): Float
		return this.getDouble(pos);

	public function toHex(length: UInt, separate: Bool): String {
		final s = new StringBuffer();

		inline function addHex(pos: UInt): Void {
			final byte = getUI8(pos);
			s.addChar(hexChars[byte >> 4]);
			s.addChar(hexChars[byte & 15]);
		}

		if (separate && UInt.one < length) {
			final lastPos = length.minusOne().unwrap();
			for (pos in 0...lastPos) {
				addHex(pos);
				s.addChar(' '.code);
			}
			addHex(lastPos);
		} else for (pos in 0...length) addHex(pos);

		return s.toString();
	}

	extern inline function get_internal()
		return this;
}
