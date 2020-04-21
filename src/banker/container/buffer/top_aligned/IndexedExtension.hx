package banker.container.buffer.top_aligned;

class IndexedExtension {
	/** @see `banker.container.interfaces.Indexed` **/
	public static inline function get<T>(_this: TopAlignedBuffer<T>, index: UInt): T {
		assert(index < _this.size, _this.tag, "Out of bounds.");
		return _this.vector[index];
	}

	/** @see `banker.container.interfaces.Indexed` **/
	public static inline function set<T>(
		_this: TopAlignedBuffer<T>,
		index: UInt,
		value: T
	): T {
		assert(index < _this.size, _this.tag, "Out of bounds.");
		return _this.vector[index] = value;
	}

	/**
		Inserts `value` to this list at the position `index`.
		Each existing elements at and after `index` shifts to the next index.
		O(n) complexity.
		@return `value`
		@see `banker.container.interfaces.Indexed`
	**/
	public static inline function insertAt<T>(
		_this: TopAlignedBuffer<T>,
		index: UInt,
		value: T
	): T {
		final size = _this.size;
		assert(size < _this.capacity, _this.tag, "The list is full.");

		var movingElementCount = size - index;
		var vector = _this.vector;
		vector.blitInternal(index, index.plusOne(), movingElementCount);
		vector[index] = value;

		_this.setSize(size.plusOne());

		return value;
	}

	/** @see `banker.container.interfaces.Indexed` **/
	public static inline function removeAt<T>(_this: TopAlignedBuffer<T>, index: UInt): T {
		final size = _this.size;
		assert(index < size, _this.tag, "Out of bound.");

		return _this.removeAtInternal(_this.vector, size, index);
	}
}
