package banker.type_extension;

class FloatExtension {
	/**
		Casts `this` to `Int`.
		- On cpp, uses `cpp.NativeMath.fastInt()`.
		- Otherwise just `Std.int(this)`.
	**/
	extern public static inline function toInt(_this: Float): Int {
		#if cpp
		return cpp.NativeMath.fastInt(_this);
		#else
		return Std.int(_this);
		#end
	}
}
