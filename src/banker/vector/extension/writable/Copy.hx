package banker.vector.extension.writable;

class Copy {
	/**
		Copies elements from source to destination position within a same vector.
	**/
	public static inline function blitInternal<T>(
		_this: WritableVector<T>,
		sourcePosition: Int,
		destinationPosition: Int,
		rangeLength: Int
	): Void {
		assert(sourcePosition + rangeLength <= _this.length);
		assert(destinationPosition + rangeLength <= _this.length);
		VectorTools.blit(_this, sourcePosition, _this, destinationPosition, rangeLength);
	}
}
