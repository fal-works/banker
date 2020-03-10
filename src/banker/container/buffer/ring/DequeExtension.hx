package banker.container.buffer.ring;

class DequeExtension {
	/** @see `banker.container.interfaces.Deque` **/
	public static inline function pushBack<T>(_this: RingBuffer<T>, value: T): Void {
		final size = _this.size;
		final capacity = _this.capacity;
		assert(size < capacity, _this.tag, "The queue is full.");

		final tailIndex = _this.tailIndex;
		_this.vector[tailIndex] = value;

		final nextTailIndex = tailIndex + 1;
		_this.tailIndex = if (nextTailIndex < capacity) nextTailIndex else 0;

		_this.setSize(size + 1);
	}

	/** @see `banker.container.interfaces.Deque` **/
	public static inline function popFront<T>(_this: RingBuffer<T>): T {
		final size = _this.size;
		assert(size > 0, _this.tag, "The queue is empty.");

		final headIndex = _this.headIndex;
		final nextHeadIndex = headIndex + 1;

		_this.headIndex = if (nextHeadIndex < _this.capacity) nextHeadIndex else 0;
		_this.setSize(size - 1);

		return _this.vector[headIndex];
	}

	/** @see `banker.container.interfaces.Deque` **/
	public static inline function pushFront<T>(_this: RingBuffer<T>, value: T): Void {
		final size = _this.size;
		final capacity = _this.capacity;
		assert(size < capacity, _this.tag, "The queue is full.");

		final headIndex = _this.headIndex;

		final nextHeadIndex = if (headIndex > 0) headIndex - 1 else capacity - 1;
		_this.headIndex = nextHeadIndex;
		_this.vector[nextHeadIndex] = value;

		_this.setSize(size + 1);
	}

	/** @see `banker.container.interfaces.Deque` **/
	public static inline function popBack<T>(_this: RingBuffer<T>): T {
		final size = _this.size;
		assert(size > 0, _this.tag, "The queue is empty.");

		final tailIndex = _this.tailIndex;
		final nextTailIndex = if (tailIndex > 0) tailIndex - 1 else _this.capacity - 1;

		_this.tailIndex = nextTailIndex;
		_this.setSize(size - 1);

		return _this.vector[nextTailIndex];
	}
}
