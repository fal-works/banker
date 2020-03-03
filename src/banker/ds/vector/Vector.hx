package banker.ds.vector;

import banker.integration.RawVector;

/**
	Fixed-length non-writable array.
**/
@:forward(length, toArray)
abstract Vector<T>(RawVector<T>) {
	/**
		@return Shallow copy of `array` as `Vector<T>`.
	**/
	public static inline function fromArrayCopy<T>(array: Array<T>): Vector<T>
		return fromData(RawVector.fromArrayCopy(array));

	/**
		Creates a vector filled with the given value.
	**/
	public static inline function createFilled<T>(length: Int, fillValue: T): Vector<T>
		return new WritableVector<T>(length).fill(fillValue).ref.nonWritable();

	/**
		Creates a vector populated using the given factory function.
	**/
	public static inline function createPopulated<T>(
		length: Int,
		factory: Void->T
	): Vector<T>
		return new WritableVector<T>(length).populate(factory).ref.nonWritable();

	/**
		Casts `data` from `RawVector<T>` to `Vector<T>`. For internal use.
	**/
	static inline function fromData<T>(data: RawVector<T>): Vector<T>
		return cast data;

	public var ref(get, never): VectorReference<T>;

	inline function get_ref(): VectorReference<T>
		return this;

	var data(get, never): RawVector<T>;

	inline function get_data()
		return this;

	@:op([]) public inline function get(index: Int): T
		return this[index];

	@:to inline function toReference<T>(): VectorReference<T>
		return this;
}
