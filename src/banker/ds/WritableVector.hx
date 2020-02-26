package banker.ds;

import banker.ds.WritableVectorTools.fromData;

/**
 * Fixed-length writable array with extended functions.
 */
@:forward(length, data, toArray, map, forEach, forEachIn, sliceToArray, indexOf, contains, findFirstOccurrence, equals)
@:access(banker.ds.Vector)
@:allow(banker.ds.WritableVectorExtension, banker.ds.WritableVectorTools)
@:using(banker.ds.WritableVectorExtension)
abstract WritableVector<T>(Vector<T>) to Vector<T> {
	// ---- instance core -------------------------------------------------------
	public inline function new(length: Int)
		this = new Vector<T>(length);

	@:op([]) public inline function get(index: Int): T
		return this[index];

	@:op([]) public inline function set(index: Int, value: T): T {
		#if safe
		if (index < 0 || index >= this.length)
			throw namelessError('index ${index} is out of bound.');
		#end
		return this.data[index] = value;
	}

	public inline function readonly(): Vector<T>
		return this;

	// ---- functional methods --------------------------------------------------

	public inline function map<S>(callback: T->S): WritableVector<S>
		return writable(this.map(callback));

	public inline function forEachIndex(
		callback: T->Int->WritableVector<T>->Void
	): Void {
		final len = this.length;
		var i = 0;
		while (i < len) {
			callback(this[i], i, writable(this));
			++i;
		}
	}

	public inline function filter<T>(predicate: T->Bool): WritableVector<T>
		return writable(this.filter(predicate));

	// ---- copy methods --------------------------------------------------------

	public inline function copy<T>()
		return writable(this.copy());

	public function subVector<T>(startPosition: Int, ?length: Int): Vector<T>
		return writable(this.subVector(startPosition, length));

	public function slice<T>(startPosition: Int, endPosition: Int): WritableVector<T>
		return writable(this.slice(startPosition, endPosition));

	// ---- scan methods --------------------------------------------------------

	public inline function validateNoNull<T>(?errorMessage: String): WritableVector<T>
		return writable(this.validateNoNull(errorMessage));

	// ---- fill methods --------------------------------------------------------

	/**
	 * Fills vector with `value`.
	 * @return Filled `this`.
	 */
	public inline function fill(value: T): WritableVector<T>
		return fromData(this.data.fill(value));

	/**
	 * Fills vector with `null`.
	 * @return Nullified `this`.
	 */
	public inline function nullify(): WritableVector<T>
		return @:nullSafety(Off) writable(this).fill(null);

	// ---- private methods -----------------------------------------------------

	static inline function writable<T>(vector: Vector<T>): WritableVector<T>
		return cast vector;
}
