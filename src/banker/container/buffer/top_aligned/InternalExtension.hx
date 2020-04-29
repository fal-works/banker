package banker.container.buffer.top_aligned;

class InternalExtension {
	/**
		Adds `element` to `this`. Duplicates are allowed.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
	**/
	public static inline function pushDuplicatesAllowed<T>(
		_this: TopAlignedBuffer<T>,
		index: UInt,
		element: T
	): Void {
		_this.vector[index] = element;
		_this.setSize(index.plusOne());
	}

	/**
		Adds `element` to `this`.
		Duplicates are not allowed; It has no effect if `element` already exists in `this`.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
	**/
	public static inline function pushDuplicatesPrevented<T>(
		_this: TopAlignedBuffer<T>,
		index: UInt,
		element: T
	): Void {
		final vector = _this.vector;
		if (!vector.ref.hasIn(element, UInt.zero, index)) {
			vector[index] = element;
			_this.setSize(index.plusOne());
		}
	}

	/**
		Adds all elements in `vector` to `this`.
		Duplicates are allowed.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
	**/
	public static inline function pushFromVectorDuplicatesAllowed<T>(
		_this: TopAlignedBuffer<T>,
		index: UInt,
		otherVector: VectorReference<T>,
		otherVectorLength: UInt
	): Void {
		VectorTools.blit(
			otherVector,
			UInt.zero,
			_this.vector,
			index,
			otherVectorLength
		);
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
		index: UInt,
		otherVector: VectorReference<T>,
		otherVectorLength: UInt
	): Void {
		final thisVector = _this.vector;
		var readIndex = UInt.zero;
		var writeIndex = index;
		while (readIndex < otherVectorLength) {
			final element = otherVector[readIndex];
			if (!thisVector.ref.hasIn(element, UInt.zero, writeIndex)) {
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
		currentSize: UInt,
		index: UInt
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
		currentSize: UInt,
		index: UInt
	): T {
		final removed = vector[index];
		final nextSize = currentSize - 1;
		vector.blitInternal(index.plusOne(), index, nextSize - index);
		_this.setSize(nextSize);

		return removed;
	}

	/**
		Removes all elements that match `predicate`.
		The order is not preserved.

		@return `true` if any found and removed.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.removeAllInternal()`
	**/
	@:access(sinker.UInt)
	public static inline function removeSwapAll<T>(
		_this: TopAlignedBuffer<T>,
		predicate: (element: T) -> Bool
	): Bool {
		final vector = _this.vector;

		var found = false;
		var len = _this.size.int();
		var i = UInt.zero;
		while (i < len) {
			if (!predicate(vector[i])) {
				++i;
				continue;
			}

			--len;
			vector[i] = vector[new UInt(len)];
			found = true;
		}

		_this.setSize(new UInt(len));

		return found;
	}

	/**
		Removes all elements that match `predicate`.
		The order is preserved.

		@return `true` if any found and removed.
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.removeAllInternal()`
	**/
	public static inline function removeShiftAll<T>(
		_this: TopAlignedBuffer<T>,
		predicate: (value: T) -> Bool
	): Bool {
		final size = _this.size;
		final vector = _this.vector;

		var found = false;
		var readIndex = UInt.zero;
		var writeIndex = UInt.zero;

		while (readIndex < size) {
			final readingElement = vector[readIndex];
			++readIndex;

			if (!predicate(readingElement)) {
				vector[writeIndex] = readingElement;
				++writeIndex;
				continue;
			}

			found = true;
		}

		_this.setSize(writeIndex);

		return found;
	}
}
