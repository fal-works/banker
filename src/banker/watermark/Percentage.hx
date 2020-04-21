package banker.watermark;

using StringTools;

import sneaker.string_buffer.StringBuffer;

/**
	Naive implementation of persentage type for the watermark feature.

	Internally this is an integer representation.
	No boundary checks implemented, however the values out of the range
	from 0 to 100 should not be used.
**/
@:notNull
abstract Percentage(Int) {
	/** Special value used as an alternative to `null`. **/
	public static inline final none = new Percentage(-1);

	/**
		Converts from `Float`. (valid range: 0.0 to 1.0)
	**/
	@:from public static inline function fromFloat(ratio: Float) {
		return new Percentage(Math.round(100 * ratio));
	}

	/**
		Casts from `Int`. (valid range: 0 to 100)
	**/
	public static inline function fromInt(value: Int) {
		return new Percentage(value);
	}

	/**
		@return `Int` representaion. (valid range: 0 to 100)
	**/
	public inline function int(): Int
		return this;

	/**
		@return `Float` representaion. (valid range: 0.0 to 1.0)
	**/
	public inline function toFloat(): Float
		return 0.01 * this;

	/**
		@return `String` representation, such as `100%`. Left-padded.
	**/
	@:to public inline function toString(): String
		return '${Std.string(this).lpad(" ", 3)}%';

	/**
		Adds the `String` representation of `this` to `buffer`.
		@return `buffer`
	**/
	public inline function addStringTo(buffer: StringBuffer): StringBuffer {
		buffer.add(Std.string(this).lpad(" ", 3));
		buffer.addChar("%".code);
		return buffer;
	}

	inline function new(value: Int)
		this = value;

	@:op(A == B)
	static function equal(a: Percentage, b: Percentage): Bool;

	@:op(A == B) @:commutative
	static function equalInt(a: Percentage, b: Int): Bool;

	@:op(A != B)
	static function notEqual(a: Percentage, b: Percentage): Bool;

	@:op(A != B) @:commutative
	static function notEqualInt(a: Percentage, b: Int): Bool;

	@:op(A < B)
	static function lessThan(a: Percentage, b: Percentage): Bool;

	@:op(A < B)
	static function lessThanInt(a: Percentage, b: Int): Bool;

	@:op(A < B)
	static function intLessThan(a: Int, b: Percentage): Bool;

	@:op(A <= B)
	static function lessThanEqual(a: Percentage, b: Percentage): Bool;

	@:op(A <= B)
	static function lessThanEqualInt(a: Percentage, b: Int): Bool;

	@:op(A <= B)
	static function intLessThanEqual(a: Int, b: Percentage): Bool;

	@:op(A > B)
	static function greaterThan(a: Percentage, b: Percentage): Bool;

	@:op(A > B)
	static function greaterThanInt(a: Percentage, b: Int): Bool;

	@:op(A > B)
	static function intGreaterThan(a: Int, b: Percentage): Bool;

	@:op(A >= B)
	static function greaterThanEqual(a: Percentage, b: Percentage): Bool;

	@:op(A >= B)
	static function greaterThanEqualInt(a: Percentage, b: Int): Bool;

	@:op(A >= B)
	static function intGreaterThanEqual(a: Int, b: Percentage): Bool;
}
