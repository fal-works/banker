package banker.vector;

import banker.vector.internal.RawVector;

/**
	Fixed-length writable array.
**/
@:forward(length, toArray)
// @formatter:off
@:using(
	banker.vector.extension.writable.Write,
	banker.vector.extension.writable.Fill,
	banker.vector.extension.writable.Functional
) // @formatter:on
@:allow(banker.vector)
@:notNull
abstract WritableVector<T>(RawVector<T>) from RawVector<T> {
	/**
		@return Shallow copy of `array` as `WritableVector<T>`.
	**/
	public static inline function fromArrayCopy<T>(array: Array<T>): WritableVector<T>
		return RawVector.fromArrayCopy(array);

	/**
		`VectorReference` representation of `this`.
	**/
	public var ref(get, never): VectorReference<T>;

	inline function get_ref(): VectorReference<T>
		return this;

	public inline function new(length: Int)
		this = new RawVector<T>(length);

	@:op([]) public inline function get(index: Int): T {
		#if !macro
		assert(index >= 0 && index < this.length, null, "Out of bound.");
		#end
		return this[index];
	}

	@:op([]) public inline function set(index: Int, value: T): T {
		#if !macro
		assert(index >= 0 && index < this.length, null, "Out of bound.");
		#end
		return this[index] = value;
	}

	@:to inline function toReference<T>(): VectorReference<T>
		return this;

	inline function nonWritable(): Vector<T>
		return this;
}
