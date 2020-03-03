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

	var data(get, never): RawVector<T>;

	inline function get_data()
		return this;

	@:op([]) public inline function get(index: Int): T
		return this[index];

	inline function writable(): WritableVector<T>
		return this;
}
