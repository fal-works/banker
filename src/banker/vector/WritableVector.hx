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
		@return A dummy vector with zero length.
	**/
	public static extern inline function createZero<T>(): WritableVector<T>
		return RawVector.createZero();

	/**
		@return Shallow copy of `array` as `WritableVector<T>`.
	**/
	public static inline function fromArrayCopy<T>(array: Array<T>): WritableVector<T>
		return RawVector.fromArrayCopy(array);

	/**
		`VectorReference` representation of `this`.
	**/
	public var ref(get, never): VectorReference<T>;

	extern inline function get_ref(): VectorReference<T>
		return this;

	public extern inline function new(length: UInt)
		this = new RawVector<T>(length);

	@:op([]) public extern inline function get(index: UInt): T {
		#if !macro
		assert(index < this.length, null, "Out of bound.");
		#end
		return this[index];
	}

	@:op([]) public extern inline function set(index: UInt, value: T): T {
		#if !macro
		assert(index < this.length, null, "Out of bound.");
		#end
		return this[index] = value;
	}

	@:to extern inline function toReference<T>(): VectorReference<T>
		return this;

	extern inline function nonWritable(): Vector<T>
		return this;
}
