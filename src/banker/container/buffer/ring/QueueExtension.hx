package banker.container.buffer.ring;

class QueueExtension {
	/**
		Adds `value` as the back/last/newest element of `this`.
		Duplicates are allowed.
	**/
	public static inline function enqueue<T>(_this: RingBuffer<T>, value: T): Void {
		final size = _this.size;
		final capacity = _this.capacity;
		assert(size < capacity, _this.tag, "The queue is full.");

		final tailIndex = _this.tailIndex;
		_this.vector[tailIndex] = value;

		final nextTailIndex = tailIndex + 1;
		_this.tailIndex = if (nextTailIndex < capacity) nextTailIndex else 0;

		_this.internalSize = size + 1;

		#if banker_watermark_enable
		_this.updateWatermark(_this.usage()); // Currently does not work
		#end
	}

	/**
	 * Removes the front/top/oldest element from `this`.
	 * @return Removed element.
	 */
	public static inline function dequeue<T>(_this: RingBuffer<T>): T {
		final size = _this.size;
		assert(size > 0, _this.tag, "The queue is empty.");

		final headIndex = _this.headIndex;
		final nextHeadIndex = headIndex + 1;

		_this.headIndex = if (nextHeadIndex < _this.capacity) nextHeadIndex else 0;
		_this.internalSize = size - 1;

		return _this.vector[headIndex];
	}
}
