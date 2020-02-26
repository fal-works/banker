package banker.ds;

import banker.ds.VectorTools.fromData;
import banker.ds.VectorTools.fromArrayCopy;

typedef VectorData<T> = NaiveVector<T>;

/**
 * Fixed-length read-only array with extended functions.
 */
@:allow(banker.ds.VectorExtension, banker.ds.VectorTools)
@:forward(length, toArray)
@:using(banker.ds.VectorExtension)
abstract Vector<T>(VectorData<T>) {
	// ---- instance core -------------------------------------------------------

	/** Internal accessor to `this` as the underlying type. */
	var data(get, never): VectorData<T>;

	inline function get_data()
		return this;

	public inline function new(length: Int)
		this = new VectorData<T>(length);

	@:op([]) public inline function get(index: Int): T {
		assert(index >= 0 && index < this.length, null, "Out of bound.");
		return this[index];
	}

	// ---- functional methods --------------------------------------------------

	/**
	 * Creates a new Vector by applying function `callback` to all elements of `this`.
	 */
	public inline function map<S>(callback: T->S): Vector<S>
		return fromData(this.map(callback));

	/**
	 * Runs `callback` for each element in `this` vector.
	 */
	public inline function forEach(callback: T->Void): Void {
		final len = this.length;
		var i = 0;
		while (i < len) {
			callback(this[i]);
			++i;
		}
	}

	/**
	 * Runs `callback` for each element in `this` vector from `startIndex` until (but not including) `endIndex`.
	 */
	public inline function forEachIn(
		startIndex: Int,
		endIndex: Int,
		callback: T->Void
	): Void {
		var i = startIndex;
		while (i < endIndex) {
			callback(this[i]);
			++i;
		}
	}

	/**
	 * Runs `callback` for each element in `this` vector.
	 */
	public inline function forEachIndex(
		callback: (
			element: T,
			index: Int,
			vector: Vector<T>
		) -> Void
	): Void {
		final len = this.length;
		var i = 0;
		while (i < len) {
			callback(this[i], i, fromData(this));
			++i;
		}
	}

	/**
	 * Creates a new vector by filtering elements of `this` with `predicate`.
	 * @param predicate Function that returns true if the element should be remain.
	 */
	public function filter<T>(predicate: T->Bool): Vector<T> {
		// ? use Lambda.filter?

		final len = this.length;

		final buffer = new Array<T>();
		var i = 0;
		while (i < len) {
			final item = this[i];
			if (predicate(item))
				buffer.push(item);
			++i;
		}

		return fromArrayCopy(buffer);
	}

	// ---- copy methods --------------------------------------------------------

	/**
	 * @return Shallow copy of `this`.
	 */
	public inline function copy(): Vector<T>
		return fromData(this.copy());

	/**
	 * Creates a new sub-vector of `this` by shallow-copying the given range.
	 * @param startPosition The position in `this` to begin.
	 * @param length The length of the range to be copied.
	 */
	public inline function subVector(startPosition: Int, length: Int): Vector<T>
		return fromData(this.sub(startPosition, length));

	/**
	 * Creates a new vector by slicing `this`.
	 * @param startPosition The position in `this` to begin (included).
	 * @param endPosition The position in `this` to end (not included).
	 */
	public inline function slice<T>(startPosition: Int, endPosition: Int): Vector<T>
		return fromData(this.sub(startPosition, endPosition - startPosition));

	/**
	 * Creates a new array by slicing `this`.
	 * @param startPosition The position in `this` to begin (included).
	 * @param endPosition The position in `this` to end (not included).
	 */
	public function sliceToArray<T>(startPosition: Int, endPosition: Int): Array<T>
		return [for (i in startPosition...endPosition) this[i]];

	// ---- search methods ------------------------------------------------------

	/**
	 * Searches `element` in `this` vector and returns the index number.
	 * @param element The element to search.
	 * @param fromIndex The index to start the search.
	 * @return The found index. `-1` if not found.
	 */
	public function indexOf<T>(element: T, fromIndex: Int): Int {
		final len = this.length;
		var i = fromIndex;
		while (i < len) {
			if (this[i] == element)
				return i;
			++i;
		}

		return -1;
	}

	/**
	 * @param element Element to search.
	 * @return `true` if this list contains `element`.
	 */
	public inline function contains(element: T): Bool
		return indexOf(element, 0) >= 0;

	/**
	 * Finds the first occurrence of the element.
	 * @param predicate Function that returns true if the given element meets the condition.
	 * @return First element that matches to the given filter. Null if not found.
	 */
	public function findFirstOccurrence<T>(predicate: T->Bool): Null<T> {
		var element: T;

		final len = this.length;
		var i = 0;
		while (i < len) {
			element = this[i];
			if (predicate(element))
				return element;

			++i;
		}

		return null;
	}

	// ---- scan methods --------------------------------------------------------

	/**
	 * Checks that the vector contains no null values (only in safe mode).
	 * @return `this` vector.
	 */
	public inline function validateNoNull<T>(
		errorMessage: String = "Found null."
	): Vector<T> {
		assert(indexOf(null, 0) >= 0, null, errorMessage);
		return fromData(this);
	}

	/**
	 * Checks that two vectors have same contents.
	 * Each element will be compared with the `!=` operator.
	 * @return `true` if equal.
	 */
	public function equals<T>(otherVector: Vector<T>): Bool {
		final len = this.length;

		if (len != otherVector.length)
			return false;

		var i = 0;
		while (i < len) {
			if (this[i] != otherVector[i])
				return false;
			++i;
		}

		return true;
	}
}
