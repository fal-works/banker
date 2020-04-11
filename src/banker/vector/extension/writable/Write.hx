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
}
