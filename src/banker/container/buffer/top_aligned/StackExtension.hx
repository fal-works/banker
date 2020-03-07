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
		final index = _this.nextFreeSlotIndex - 1;
		assert(index >= 0, _this.tag, "The list is empty.");

		_this.setSize(index);

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
}
