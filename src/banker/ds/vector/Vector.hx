package banker.ds.vector;

import banker.integration.RawVector;

/**
	Fixed-length read-only array with extended functions.
**/
@:forward(
	length,
	data,
	toArray
)
// @formatter:off
@:using(
	banker.ds.vector.extension.Copy,
	banker.ds.vector.extension.Functional,
	banker.ds.vector.extension.Functional.ReadOnlyFunctional,
	banker.ds.vector.extension.Scan,
	banker.ds.vector.extension.Search
) // @formatter:on
abstract Vector<T>(WritableVector<T>) from WritableVector<T> {
	/**
		@return Shallow copy of `array` as `Vector<T>`.
	**/
	public static inline function fromArrayCopy<T>(array: Array<T>): Vector<T>
		return WritableVector.fromArrayCopy(array);

	/**
		Creates a vector filled with the given value.
	**/
	public static inline function createFilled<T>(length: Int, fillValue: T): Vector<T> {
		return WritableVector.createFilled(length, fillValue);
	}

	/**
		Creates a vector populated using the given factory function.
	**/
	public static inline function createPopulated<T>(
		length: Int,
		factory: Void->T
	): Vector<T> {
		return WritableVector.createPopulated(length, factory);
	}

	@:op([]) public inline function get(index: Int): T
		return this[index];

	public inline function copy(): Vector<T>
		return this.copy();

	public inline function map<S>(f: T->S): Vector<S>
		return this.map(f);

	public inline function sub(pos: Int, len: Int): Vector<T>
		return this.sub(pos, len);

	inline function writable(): WritableVector<T>
		return this;
}
