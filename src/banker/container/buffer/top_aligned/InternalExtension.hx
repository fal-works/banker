package banker.container.buffer.top_aligned;

class InternalExtension {
	/**
		Adds `element` to `this`. Duplicates are allowed.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
	**/
	public static inline function pushDuplicatesAllowed<T>(
		_this: TopAlignedBuffer<T>,
		index: Int,
		element: T
	): Void {
		_this.vector[index] = element;
		_this.setSize(index + 1);
	}

	/**
		Adds `element` to `this`.
		Duplicates are not allowed; It has no effect if `element` already exists in `this`.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
	**/
	public static inline function pushDuplicatesPrevented<T>(
		_this: TopAlignedBuffer<T>,
		index: Int,
		element: T
	): Void {
		final vector = _this.vector;
		if (!vector.ref.hasIn(element, 0, index)) {
			vector[index] = element;
			_this.setSize(index + 1);
		}
	}

	/**
		Adds all elements in `vector` to `this`.
		Duplicates are allowed.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
	**/
	public static inline function pushFromVectorDuplicatesAllowed<T>(
		_this: TopAlignedBuffer<T>,
		index: Int,
		otherVector: VectorReference<T>,
		otherVectorLength: Int
	): Void {
		VectorTools.blit(otherVector, 0, _this.vector, index, otherVectorLength);
		_this.setSize(index + otherVectorLength);
	}

	/**
		Adds all elements in `vector` to `this`.
		Duplicates are not allowed; Only the elements that do not exist in `this` are pushed.
		O(n^2) complexity.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
	**/
	public static inline function pushFromVectorDuplicatesPrevented<T>(
		_this: TopAlignedBuffer<T>,
		index: Int,
		otherVector: VectorReference<T>,
		otherVectorLength: Int
	): Void {
		final thisVector = _this.vector;
		var readIndex = 0;
		var writeIndex = index;
		while (readIndex < otherVectorLength) {
			final element = otherVector[readIndex];
			if (!thisVector.ref.hasIn(element, 0, writeIndex)) {
				thisVector[writeIndex] = element;
				++writeIndex;
			}
			++readIndex;
		}
		_this.setSize(writeIndex);
	}

	/**
		Removes the element at `index` by overwriting it with that at the last index
		(thus the order is not preserved).
		O(1) complexity.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
	**/
	public static inline function removeSwapAt<T>(
		_this: TopAlignedBuffer<T>,
		vector: WritableVector<T>,
		currentSize: Int,
		index: Int
	): T {
		final removed = vector[index];

		final lastIndex = currentSize - 1;
		vector[index] = vector[lastIndex];
		_this.nextFreeSlotIndex = lastIndex;

		return removed;
	}

	/**
		Removes the element at `index` by overwriting it with that at the last index
		(thus the order is not preserved).
		O(1) complexity.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
	**/
	public static inline function removeShiftAt<T>(
		_this: TopAlignedBuffer<T>,
		vector: WritableVector<T>,
		currentSize: Int,
		index: Int
	): T {
		final removed = vector[index];
		vector.blitInternal(index + 1, index, currentSize - 1 - index);
		_this.setSize(currentSize - 1);

		return removed;
	}
}
