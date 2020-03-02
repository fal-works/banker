package banker.ds.vector.extension;

@:access(banker.ds.vector.Vector)
class Scan {
	/**
	 * Checks that the vector contains no null values (only in safe mode).
	 * @return `this` vector.
	 */
	@:generic
	public static inline function assertNoNull<T>(
		_this: Vector<T>,
		?errorMessage: String
	): WritableVector<T> {
		assert(_this.contains(null), null, errorMessage);
		return _this.writable();
	}

	/**
	 * Checks that two vectors have same contents.
	 * Each element will be compared with the `!=` operator.
	 * @return `true` if equal.
	 */
	@:generic
	public static function equals<T>(_this: Vector<T>, otherVector: Vector<T>): Bool {
		final len = _this.length;

		if (len != otherVector.length)
			return false;

		var i = 0;
		while (i < len) {
			if (_this[i] != otherVector[i]) return false;
			++i;
		}

		return true;
	}
}

class ReadOnlyScan {
	/**
	 * Checks that the vector contains no null values (only in safe mode).
	 * @return `this` vector.
	 */
	@:generic
	public static inline function assertNoNull<T>(
		_this: Vector<T>,
		?errorMessage: String
	): Vector<T> {
		return Scan.assertNoNull(_this, errorMessage);
	}

	// forward: equals
}
