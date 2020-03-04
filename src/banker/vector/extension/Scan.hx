package banker.vector.extension;

class Scan {
	/**
		Checks that two vectors have same contents.
		Each element will be compared with the `!=` operator.
		@return `true` if equal.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function equals<T>(
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
	#if !banker_generic_disable
	@:generic
	#end
	public static function joinUntil<T>(
		_this: VectorReference<T>,
		endIndex: Int,
		separator: String
	): String {
		final buffer = new StringBuf();
		buffer.add(_this[0]);

		for (i in 1...endIndex) {
			buffer.add(separator);
			buffer.add(_this[i]);
		}

		return buffer.toString();
	}

	/**
		Joins elements of `this` and returns a `String` representation.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function join<T>(_this: VectorReference<T>, separator: String): String {
		return joinUntil(_this, _this.length, separator);
	}
}
