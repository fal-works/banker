package banker.ds.vector;

/**
	Fixed-length read-only array with extended functions.
**/
@:forward(
	length,
	data,
	toArray,
	sliceToArray,
	forEachIn,
	forEach,
	equals,
	toString
)
// @formatter:off
@:using(
	banker.ds.vector.extension.Copy.ReadOnlyCopy,
	banker.ds.vector.extension.Functional.ReadOnlyFunctional,
	banker.ds.vector.extension.Scan.ReadOnlyScan,
	banker.ds.vector.extension.Search
) // @formatter:on
abstract Vector<T>(WritableVector<T>) from WritableVector<T> {
	// ---- create functions ----------------------------------------------------

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

	// ---- instance core -------------------------------------------------------

	@:op([]) public inline function get(index: Int): T
		return this[index];

	public inline function copy(): Vector<T>
		return this.copy();

	public inline function map<S>(f: T->S): Vector<S>
		return this.map(f);

	public inline function sub(pos: Int, len: Int): Vector<T>
		return this.sub(pos, len);

	// ---- internal ------------------------------------------------------------

	inline function writable(): WritableVector<T>
		return this;
}
