package banker.ds.vector;

import banker.integration.RawVector;

/**
	Fixed-length read-only array with extended functions.
**/
@:forward(length, toArray)
// @formatter:off
@:using(
	banker.ds.vector.extension.Copy,
	banker.ds.vector.extension.Functional,
	banker.ds.vector.extension.Scan,
	banker.ds.vector.extension.Search
) // @formatter:on
@:access(banker.ds.vector.WritableVector)
@:allow(banker.ds.vector.VectorTools)
abstract VectorReference<T>(RawVector<T>) from RawVector<T> {
	/**
		@return Shallow copy of `array` as `VectorReference<T>`.
	**/
	public static inline function fromArrayCopy<T>(array: Array<T>): VectorReference<T>
		return WritableVector.fromArrayCopy(array);

	/**
		Creates a vector filled with the given value.
	**/
	public static inline function createFilled<T>(length: Int, fillValue: T): VectorReference<T> {
		return WritableVector.createFilled(length, fillValue);
	}

	/**
		Creates a vector populated using the given factory function.
	**/
	public static inline function createPopulated<T>(
		length: Int,
		factory: Void->T
	): VectorReference<T> {
		return WritableVector.createPopulated(length, factory);
	}

	@:op([]) public inline function get(index: Int): T
		return this[index];

	public inline function copy(): VectorReference<T>
		return this.copy();

	public inline function map<S>(f: T->S): VectorReference<S>
		return this.map(f);

	public inline function sub(pos: Int, len: Int): VectorReference<T>
		return this.sub(pos, len);

	inline function writable(): WritableVector<T>
		return this;
}
