package banker.container.buffer.top_aligned;

class StackExtension {
	/** @see `banker.container.interfaces.Stack` **/
	public static inline function push<T>(_this: TopAlignedBuffer<T>, element: T): Void {
		final index = _this.nextFreeSlotIndex;
		assert(index < _this.capacity, _this.tag, "The list is full.");

		_this.pushInternal(index, element);
	}

	/** @see `banker.container.interfaces.Stack` **/
	public static inline function pop<T>(_this: TopAlignedBuffer<T>): T {
		final maybeIndex = _this.nextFreeSlotIndex.minusOne();
		assert(maybeIndex.isSome(), _this.tag, "The list is empty.");

		final index = maybeIndex.unwrap();
		_this.setSize(index);

		return _this.vector[index];
	}

	/** @see `banker.container.interfaces.Stack` **/
	public static inline function peek<T>(_this: TopAlignedBuffer<T>): T {
		final maybeIndex = _this.nextFreeSlotIndex.minusOne();
		assert(maybeIndex.isSome(), _this.tag, "The list is empty.");

		return _this.vector[maybeIndex.unwrap()];
	}

	/** @see `banker.container.interfaces.Stack` **/
	public static inline function pushFromVector<T>(
		_this: TopAlignedBuffer<T>,
		otherVector: VectorReference<T>
	): Void {
		final index = _this.nextFreeSlotIndex;
		final otherVectorLength = otherVector.length;
		assert(
			index + otherVectorLength <= _this.capacity,
			_this.tag,
			"Not enough space."
		);

		_this.pushFromVectorInternal(index, otherVector, otherVectorLength);
	}

	/** @see `banker.container.interfaces.Stack` **/
	@:access(sinker.UInt)
	public static inline function swap<T>(_this: TopAlignedBuffer<T>): Void {
		final lastIndex = _this.nextFreeSlotIndex.minusOne().int();
		assert(lastIndex >= 1, _this.tag, "The list must have at least 2 elements.");

		_this.vector.swap(new UInt(lastIndex - 1), new UInt(lastIndex));
	}
}
