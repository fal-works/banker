package banker.binary.value_types;

@:notNull @:forward(std, int, toFloat, toString)
@:allow(banker.binary)
abstract UInt8(UInt) to UInt to Int {
	/**
		Value `0` in `UInt8` representation.
	**/
	public static extern inline final zero: UInt8 = new UInt8(0);

	/**
		Value `1` in `UInt8` representation.
	**/
	public static extern inline final one: UInt8 = new UInt8(1);

	#if debug
	static function error(v: UInt): String
		return 'Cannot cast value to UInt8: $v';
	#end

	@:from static extern inline function fromUInt(v: UInt): UInt8 {
		#if debug
		if (v != v & 0xFF) throw error(v);
		#end
		return new UInt8(v);
	}

	@:access(sinker.UInt)
	static extern inline function fromIntUnsafe(v: Int): UInt8 {
		return new UInt8(new UInt(v));
	}

	extern inline function new(v: UInt)
		this = v;
}
