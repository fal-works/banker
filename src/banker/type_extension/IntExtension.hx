package banker.type_extension;

class IntExtension {
	/**
		Divides `this` integer by `denominator`.
		- On cpp, uses `cpp.NativeMath.idiv()`.
		- Otherwise just `Std.int(this / denominator)`.
	**/
	extern public static inline function divide(_this: Int, denominator: Int): Int {
		#if cpp
		return cpp.NativeMath.idiv(_this, denominator);
		#else
		return Std.int(_this / denominator);
		#end
	}

	/**
		Runs a modulo operation.
		- On cpp, uses `cpp.NativeMath.imod()`.
		- Otherwise just `this % denominator`.
	**/
	extern public static inline function modulo(_this: Int, denominator: Int): Int {
		#if cpp
		return cpp.NativeMath.imod(_this, denominator);
		#else
		return _this % denominator;
		#end
	}

	/**
		@return `2 ^ this`. If `this` is negative, the result is inaccurate.
	**/
	public static inline function powerOf2(_this: Int): Int {
		return switch _this {
			case 0: 1;
			case 1: 2;
			case 2: 4;
			case 3: 8;
			case 4: 16;
			case 5: 32;
			case 6: 64;
			case 7: 128;
			case 8: 256;
			case 9: 512;
			case 10: 1024;
			case 11: 2048;
			case 12: 4096;
			case 13: 8192;
			case 14: 16384;
			case 15: 32768;
			case 16: 65536;
			default: Std.int(Math.pow(2, _this));
		}
	}
}
