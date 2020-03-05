package banker.container.buffer.ring;

class DequeExtension {
	/** @see `banker.container.interfaces.Deque` **/
	public static inline function pushBack<T>(_this: RingBuffer<T>, value: T): Void
		QueueExtension.enqueue(_this, value);

	/** @see `banker.container.interfaces.Deque` **/
	public static inline function popFront<T>(_this: RingBuffer<T>): T
		return QueueExtension.dequeue(_this);

	/** @see `banker.container.interfaces.Deque` **/
	public static inline function pushFront<T>(_this: RingBuffer<T>, value: T): Void {
		final size = _this.size;
		final capacity = _this.capacity;
		assert(size < capacity, _this.tag, "The queue is full.");

		final headIndex = _this.headIndex;

		final nextHeadIndex = if (headIndex > 0) headIndex - 1 else capacity - 1;
		_this.headIndex = nextHeadIndex;
		_this.vector[nextHeadIndex] = value;

		_this.internalSize = size + 1;

		#if banker_watermark_enable
		_this.updateWatermark(_this.usage()); // Currently does not work
		#end
	}

	/** @see `banker.container.interfaces.Deque` **/
	public static inline function popBack<T>(_this: RingBuffer<T>): T {
		final size = _this.size;
		assert(size > 0, _this.tag, "The queue is empty.");

		final tailIndex = _this.tailIndex;
		final nextTailIndex = if (tailIndex > 0) tailIndex - 1 else _this.capacity - 1;

		_this.tailIndex = nextTailIndex;
		_this.internalSize = size - 1;

		return _this.vector[nextTailIndex];
	}
}
