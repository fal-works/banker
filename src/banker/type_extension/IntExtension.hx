package banker.type_extension;

class IntExtension {
	/**
		Divides `this` integer by `denominator`.
		- On cpp, uses `cpp.NativeMath.idiv()`.
		- Otherwise just `Std.int(this / denominator)`.
	**/
	public static extern inline function divide(_this: Int, denominator: Int): Int {
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
	public static extern inline function modulo(_this: Int, denominator: Int): Int {
		#if cpp
		return cpp.NativeMath.imod(_this, denominator);
		#else
		return _this % denominator;
		#end
	}

	/**
		@return `pow(2, this)`. `this` should be zero or greater.
	**/
	public static extern inline function powerOf2(_this: Int): Int {
		assert(_this >= 0);
		return 1 << _this;
	}
}
