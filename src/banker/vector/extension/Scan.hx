package banker.vector.extension;

class Scan {
	/**
		Checks that two vectors have same contents.
		Each element will be compared with the `!=` operator.
		@return `true` if equal.
	**/
	public static inline function equals<T>(
		_this: VectorReference<T>,
		otherVector: VectorReference<T>
	): Bool {
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

	/**
		Joins elements of `this` and returns a `String` representation.
	**/
	public static inline function joinIn<T>(
		_this: VectorReference<T>,
		startIndex: Int,
		endIndex: Int,
		separator: String
	): String {
		final length = endIndex - startIndex;
		if (length <= 0) return "";

		final buffer = new StringBuf();
		buffer.add(_this[startIndex]);

		for (i in startIndex + 1...endIndex) {
			buffer.add(separator);
			buffer.add(_this[i]);
		}

		return buffer.toString();
	}

	/**
		Joins elements of `this` and returns a `String` representation.
	**/
	public static inline function join<T>(
		_this: VectorReference<T>,
		separator: String
	): String {
		return joinIn(_this, 0, _this.length, separator);
	}
}
