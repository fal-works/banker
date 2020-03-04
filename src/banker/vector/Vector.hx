package banker.vector;

/**
	Fixed-length non-writable array.
**/
@:forward(length, toArray)
@:allow(banker.vector)
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
		Casts `data` from `RawVector<T>` to `Vector<T>`. For internal use.
	**/
	static inline function fromData<T>(data: RawVector<T>): Vector<T>
		return cast data;

	public var ref(get, never): VectorReference<T>;

	inline function get_ref(): VectorReference<T>
		return this;

	@:op([]) public inline function get(index: Int): T
		return this[index];

	@:to inline function toReference<T>(): VectorReference<T>
		return this;

	inline function writable(): WritableVector<T>
		return WritableVector.fromData(this);
}
