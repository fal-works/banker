package banker.vector.extension.writable;

class Write {
	/**
		Copies elements from source to destination position within a same vector.
	**/
	public static inline function blitInternal<T>(
		_this: WritableVector<T>,
		sourcePosition: Int,
		destinationPosition: Int,
		rangeLength: Int
	): Void {
		#if !macro
		assert(sourcePosition + rangeLength <= _this.length);
		assert(destinationPosition + rangeLength <= _this.length);
		#end
		VectorTools.blit(
			_this,
			sourcePosition,
			_this,
			destinationPosition,
			rangeLength
		);
	}

	/**
		Swaps elements at `indexA` and `indexB`.
	**/
	public static inline function swap<T>(
		_this: WritableVector<T>,
		indexA: Int,
		indexB: Int
	): Void {
		#if !macro
		assert(indexA >= 0 && indexA < _this.length);
		assert(indexB >= 0 && indexB < _this.length);
		#end

		final tmp = _this[indexA];
		_this[indexA] = _this[indexB];
		_this[indexB] = tmp;
	}

	/**
		Reverses the order of elements in `this`.
	**/
	public static inline function reverse<T>(
		_this: WritableVector<T>
	): Void {
		final len = _this.length;
		var tmp: T;
		var i = 0;
		var k = len - 1;
		while (i < len) {
			tmp = _this[i];
			_this[i] = _this[k];
			_this[k] = tmp;
			++i;
			--k;
		}
	}
}
