package banker.container.buffer.top_aligned;

class StackExtension {
	/** @see `banker.container.interfaces.Stack` **/
	public static inline function push<T>(_this: TopAlignedBuffer<T>, element: T): Void {
		final index = _this.nextFreeSlotIndex;
		assert(index < _this.capacity, _this.tag, "The list is full.");

		_this.nextFreeSlotIndex = index + 1;

		_this.vector[index] = element;

		#if banker_watermark_enable
		updateWatermark(getUsageRatio()); // Currently does not work
		#end
	}

	/** @see `banker.container.interfaces.Stack` **/
	public static inline function pop<T>(_this: TopAlignedBuffer<T>): T {
		final index = _this.nextFreeSlotIndex - 1;
		assert(index >= 0, _this.tag, "The list is empty.");

		_this.nextFreeSlotIndex = index;

		return _this.vector[index];
	}

	/** @see `banker.container.interfaces.Stack` **/
	public static inline function peek<T>(_this: TopAlignedBuffer<T>): T {
		final index = _this.nextFreeSlotIndex - 1;
		assert(index >= 0, _this.tag, "The list is empty.");

		return _this.vector[index];
	}

	/** @see `banker.container.interfaces.Stack` **/
	public static inline function pushFromVector<T>(
		_this: TopAlignedBuffer<T>,
		vector: VectorReference<T>
	): Void {
		final index = _this.nextFreeSlotIndex;
		final increment = vector.length;
		assert(
			index + increment <= _this.capacity,
			_this.tag,
			"Not enough space."
		);

		VectorTools.blit(vector, 0, _this.vector, index, increment);
		_this.nextFreeSlotIndex = index + increment;

		#if banker_watermark_enable
		updateWatermark(getUsageRatio()); // Currently does not work
		#end
	}
}
