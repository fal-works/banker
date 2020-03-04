package banker.vector;

import banker.integration.RawVector;

/**
	Read-only reference to a vector.
**/
@:forward(length, toArray)
// @formatter:off
@:using(
	banker.vector.extension.Copy,
	banker.vector.extension.Functional,
	banker.vector.extension.Scan,
	banker.vector.extension.Search
) // @formatter:on
@:access(banker.vector.WritableVector, banker.vector.Vector)
@:allow(banker.vector.VectorTools, banker.vector.Vector)
abstract VectorReference<T>(RawVector<T>) from RawVector<T> {
	/**
		@return Shallow copy of `array` as `VectorReference<T>`.
	**/
	public static inline function fromArrayCopy<T>(array: Array<T>): VectorReference<T>
		return WritableVector.fromArrayCopy(array);

	/**
		Creates a vector filled with the given value.
	**/
	public static inline function createFilled<T>(
		length: Int,
		fillValue: T
	): VectorReference<T> {
		final v = new WritableVector(length);
		v.fill(fillValue);
		return v.ref;
	}

	/**
		Creates a vector populated using the given factory function.
	**/
	public static inline function createPopulated<T>(
		length: Int,
		factory: Void->T
	): VectorReference<T> {
		return new WritableVector<T>(length).populate(factory).ref;
	}

	var data(get, never): RawVector<T>;

	inline function get_data()
		return this;

	@:op([]) public inline function get(index: Int): T
		return this[index];

	inline function writable(): WritableVector<T>
		return WritableVector.fromData(this);

	inline function nonWritable(): Vector<T>
		return Vector.fromData(this);
}
