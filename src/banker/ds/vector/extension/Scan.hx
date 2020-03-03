package banker.ds.vector.extension;

class Scan {
	/**
		Checks that two vectors have same contents.
		Each element will be compared with the `!=` operator.
		@return `true` if equal.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function equals<T>(_this: VectorReference<T>, otherVector: VectorReference<T>): Bool {
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
