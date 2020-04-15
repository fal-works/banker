package banker.vector;

import banker.vector.internal.RawVector;

/**
	Fixed-length non-writable array.
**/
@:forward(length, toArray)
@:allow(banker.vector)
@:notNull
abstract Vector<T>(RawVector<T>) from RawVector<T> {
	/**
		@return A dummy vector with zero length.
	**/
	public static extern inline function createZero<T>(): Vector<T>
		return RawVector.createZero();

	/**
		@return Shallow copy of `array` as `Vector<T>`.
	**/
	public static inline function fromArrayCopy<T>(array: Array<T>): Vector<T>
		return RawVector.fromArrayCopy(array);

	/**
		Creates a vector filled with the given value.
	**/
	public static inline function createFilled<T>(length: Int, fillValue: T): Vector<T>
		return new WritableVector<T>(length).fill(fillValue).nonWritable();

	/**
		Creates a vector populated using the given factory function.
	**/
	public static inline function createPopulated<T>(
		length: Int,
		factory: Void->T
	): Vector<T>
		return new WritableVector<T>(length).populate(factory).nonWritable();

	/**
		`VectorReference` representation of `this`.
	**/
	public var ref(get, never): VectorReference<T>;

	extern inline function get_ref(): VectorReference<T>
		return this;

	@:op([]) public extern inline function get(index: Int): T
		return this[index];

	@:to extern inline function toReference<T>(): VectorReference<T>
		return this;

	extern inline function writable(): WritableVector<T>
		return this;
}
