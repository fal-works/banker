package banker.ds;

typedef NaiveVectorData<T> = banker.integration.Vector<T>;

/**
 * Vector type derived from `banker.integration.Vector` for internal use in `banker.ds.Vector` and other.
 */
@:access(banker.integration.Vector)
@:forward(length, toArray)
abstract NaiveVector<T>(NaiveVectorData<T>) {
	/**
	 * Casts `data` from `NaiveVectorData<T>` to `NaiveVector<T>`.
	 */
	public static inline function fromData<T>(data: NaiveVectorData<T>): NaiveVector<T>
		return cast data;

	/**
	 * @return Shallow copy of `array` as `NaiveVector<T>`.
	 */
	public static inline function fromArrayCopy<T>(array: Array<T>): NaiveVector<T>
		return fromData(NaiveVectorData.fromArrayCopy(array));

	/**
	 * Static version of `blit()`.
	 * Copies `rangeLength` of elements from `source` (beginning at `sourcePosition`) to `destination` (beginning at `destinationPosition`).
	 */
	public static inline function blit<T>(
		source: NaiveVector<T>,
		sourcePosition: Int,
		destination: NaiveVector<T>,
		destinationPosition: Int,
		rangeLength: Int
	): Void {
		assert(sourcePosition >= 0 && destinationPosition >= 0);
		assert(sourcePosition + rangeLength <= source.length);
		assert(destinationPosition + rangeLength <= destination.length);
		destination.data.blit(
			destinationPosition,
			source.data,
			sourcePosition,
			rangeLength
		);
	}

	var data(get, never): NaiveVectorData<T>;

	inline function get_data()
		return this;

	public inline function new(length: Int)
		this = new NaiveVectorData<T>(length);

	// TODO: assert
	@:op([]) public inline function get(index: Int): T
		return this[index];

	@:op([]) public inline function set(index: Int, value: T): T {
		return this[index] = value;
	}

	public inline function copy(): NaiveVector<T>
		return fromData(this.copy());

	public inline function map<S>(f: T->S): NaiveVector<S>
		return fromData(this.map(f));

	public inline function sub(pos: Int, len: Int): NaiveVector<T>
		return fromData(this.sub(pos, len));

	/**
	 * Fills the vector with `value` beginning at `startIndex` until (but not including) `endIndex`.
	 * @return Filled `this`.
	 */
	public inline function fillRange<T>(
		value: T,
		startIndex: Int,
		endIndex: Int
	): NaiveVector<T> {
		assert(startIndex >= 0 && endIndex <= this.length);
		// warn start >= end?

		for (i in startIndex...endIndex) this[i] = value;

		return fromData(this);
	}

	/**
	 * Fills the entire vector with `value`.
	 * @return Filled `this`.
	 */
	public inline function fill<T>(value: T): NaiveVector<T> {
		for (i in 0...this.length) this[i] = value;

		return fromData(this);
	}

	/**
	 * Fills the entire vector with instances created from `factory`.
	 * @return Filled `this`.
	 */
	public inline function populate<T>(factory: Void->T): NaiveVector<T> {
		assert(factory != null);
		// warn zero length?

		for (i in 0...this.length) this[i] = factory();

		return fromData(this);
	}
}
