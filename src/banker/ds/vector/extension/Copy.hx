package banker.ds.vector.extension;

@:access(banker.ds.vector.Vector)
class Copy {
	/**
	 * Returns a new concatenated vector.
	 */
	@:generic
	public static inline function concat<T>(
		_this: Vector<T>,
		otherVector: Vector<T>
	): WritableVector<T> {
		final thisLength = _this.length;
		final otherLength = otherVector.length;
		final newVector = new WritableVector(thisLength + otherLength);
		// @formatter:off
		VectorTools.blit(_this, 0, newVector, 0, thisLength);
		VectorTools.blit(otherVector, 0, newVector, thisLength, otherLength);
		// @formatter:on
		return newVector;
	}

	/**
	 * Creates a new vector by slicing `this`.
	 * @param startPosition The position in `this` to begin (included).
	 * @param endPosition The position in `this` to end (not included).
	 */
	@:generic
	public static inline function slice<T>(
		_this: Vector<T>,
		startPosition: Int,
		endPosition: Int
	): WritableVector<T> {
		return _this.sub(startPosition, endPosition - startPosition).writable();
	}

	/**
	 * Creates a new array by slicing `this`.
	 * @param startPosition The position in `this` to begin (included).
	 * @param endPosition The position in `this` to end (not included).
	 */
	@:generic
	public static function sliceToArray<T>(
		_this: Vector<T>,
		startPosition: Int,
		endPosition: Int
	): Array<T> {
		return [for (i in startPosition...endPosition) _this[i]];
	}
}

class ReadOnlyCopy {
	/** @see `Copy.concat()` */
	@:generic
	public static inline function concat<T>(
		_this: Vector<T>,
		otherVector: Vector<T>
	): Vector<T> {
		return Copy.concat(_this, otherVector);
	}

	/** @see `Copy.slice()` */
	@:generic
	public static inline function slice<T>(
		_this: Vector<T>,
		startPosition: Int,
		endPosition: Int
	): Vector<T> {
		return Copy.slice(_this, startPosition, endPosition);
	}

	// forward: sliceToArray
}
