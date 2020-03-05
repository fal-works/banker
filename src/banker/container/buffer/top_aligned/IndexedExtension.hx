package banker.container.buffer.top_aligned;

class IndexedExtension {
	/** @see `banker.container.interfaces.Indexed` **/
	public static inline function get<T>(_this: TopAlignedBuffer<T>, index: Int): T {
		assert(index < _this.size);
		return _this.vector[index];
	}


	/** @see `banker.container.interfaces.Indexed` **/
	public static inline function set<T>(
		_this: TopAlignedBuffer<T>,
		index: Int,
		value: T
	): T {
		assert(index < _this.size);
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
		index: Int,
		value: T
	): T {
		final size = _this.size;
		assert(size < _this.capacity, _this.tag, "The list is full.");

		var movingElementCount = size - index;
		var vector = _this.vector;
		vector.blitInternal(index, index + 1, movingElementCount);
		vector[index] = value;

		_this.nextFreeSlotIndex = size + 1;

		#if banker_watermark_enable
		updateWatermark(_this.getUsageRatio()); // Currently does not work
		#end

		return value;
	}

	/**
		Removes the element at a given index in the internal vector.
		O(n) complexity.
		@return The removed element.
		@see `banker.container.interfaces.Indexed`
	**/
	public static inline function removeAt<T>(_this: TopAlignedBuffer<T>, index: Int): T {
		final size = _this.size;
		assert(index >= 0 && index < size, _this.tag, "Out of bound.");

		final vector = _this.vector;
		final removed = vector[index];
		vector.blitInternal(index + 1, index, size - 1 - index);
		_this.nextFreeSlotIndex = size - 1;

		return removed;
	}
}
