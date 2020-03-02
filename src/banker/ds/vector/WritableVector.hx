package banker.ds.vector;

typedef WritableVectorData<T> = banker.integration.RawVector<T>;

/**
 * Fixed-length writable array with extended functions.
 */
@:forward(length, toArray)
// @formatter:off
@:using(
	banker.ds.vector.extension.Fill,
	banker.ds.vector.extension.Functional,
	banker.ds.vector.extension.Search,
	banker.ds.vector.extension.Scan,
	banker.ds.vector.extension.Copy
) // @formatter:on
@:allow(banker.ds.vector.VectorTools)
abstract WritableVector<T>(WritableVectorData<T>) {
	// ---- create functions ----------------------------------------------------

	/**
	 * Casts `data` from `WritableVectorData<T>` to `WritableVector<T>`.
	 */
	public static inline function fromData<T>(
		data: WritableVectorData<T>
	): WritableVector<T>
		return cast data;

	/**
	 * @return Shallow copy of `array` as `WritableVector<T>`.
	 */
	public static inline function fromArrayCopy<T>(array: Array<T>): WritableVector<T>
		return fromData(WritableVectorData.fromArrayCopy(array));

	/**
	 * Creates a vector filled with the given value.
	 */
	public static inline function createFilled<T>(
		length: Int,
		fillValue: T
	): WritableVector<T> {
		return new WritableVector<T>(length).fill(fillValue);
	}

	/**
	 * Creates a vector populated using the given factory function.
	 */
	public static inline function createPopulated<T>(
		length: Int,
		factory: Void->T
	): WritableVector<T> {
		return new WritableVector<T>(length).populate(factory);
	}

	// ---- instance core -------------------------------------------------------

	var data(get, never): WritableVectorData<T>;

	inline function get_data()
		return this;

	public inline function new(length: Int)
		this = new WritableVectorData<T>(length);

	// TODO: assert
	@:op([]) public inline function get(index: Int): T {
		assert(index >= 0 && index < this.length, null, "Out of bound.");
		return this[index];
	}

	@:op([]) public inline function set(index: Int, value: T): T {
		assert(index >= 0 && index < this.length, null, "Out of bound.");
		return this[index] = value;
	}

	public inline function copy(): WritableVector<T>
		return fromData(this.copy());

	public inline function map<S>(f: T->S): WritableVector<S>
		return fromData(this.map(f));

	public inline function sub(pos: Int, len: Int): WritableVector<T>
		return fromData(this.sub(pos, len));

	public inline function toString(): String
		return this.toArray().toString();
}
