package banker.vector.extension.writable;

class Write {
	/**
		Copies elements from source to destination position within a same vector.
	**/
	public static inline function blitInternal<T>(
		_this: WritableVector<T>,
		sourcePosition: UInt,
		destinationPosition: UInt,
		rangeLength: UInt
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
		indexA: UInt,
		indexB: UInt
	): Void {
		#if !macro
		assert(indexA < _this.length && indexB < _this.length);
		#end

		final tmp = _this[indexA];
		_this[indexA] = _this[indexB];
		_this[indexB] = tmp;
	}

	/**
		Reverses the order of elements in `this`.
	**/
	@:access(sinker.UInt)
	public static inline function reverse<T>(
		_this: WritableVector<T>
	): Void {
		final len = _this.length;

		if (!len.isZero()) {
			var tmp: T;
			var i = UInt.zero;
			var k = len;

			while (i < len) {
				--k;

				tmp = _this[i];
				_this[i] = _this[k];
				_this[k] = tmp;

				++i;
			}
		}
	}
}
