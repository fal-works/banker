package banker.linker.buffer.top_aligned;

class InternalExtension {
	/**
		Removes the key-value pair at `index` by overwriting it with that at the last index
		(thus the order is not preserved).
		O(1) complexity.

		@see `banker.linker.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
	**/
	public static inline function removeSwapAt<K, V>(
		_this: TopAlignedBuffer<K, V>,
		keyVector: WritableVector<K>,
		valueVector: WritableVector<V>,
		currentSize: Int,
		index: Int
	): Void {
		final lastIndex = currentSize - 1;
		keyVector[index] = keyVector[lastIndex];
		valueVector[index] = valueVector[lastIndex];
		_this.setSize(lastIndex);
	}

	/**
		Removes the key-value pair at `index` by shifting all entries at succeeding
		indices towards index zero (thus the order is preserved).
		O(n) complexity.

		@see `banker.linker.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
	**/
	public static inline function removeShiftAt<K, V>(
		_this: TopAlignedBuffer<K, V>,
		keyVector: WritableVector<K>,
		valueVector: WritableVector<V>,
		currentSize: Int,
		index: Int
	): Void {
		final nextSize = currentSize - 1;
		final movingRange = nextSize - index;
		keyVector.blitInternal(index + 1, index, movingRange);
		valueVector.blitInternal(index + 1, index, movingRange);
		_this.setSize(nextSize);
	}

	/**
		Removes all key-value pairs that match `predicate`.
		The order is not preserved.

		Used for implementing `banker.linker.interfaces.Set.removeAll()`.
		@return `true` if any found and removed.
	**/
	public static inline function removeSwapAll<K, V>(
		_this: TopAlignedBuffer<K, V>,
		predicate: (key: K, value: V) -> Bool
	): Bool {
		final keys = _this.keyVector;
		final values = _this.valueVector;

		var found = false;
		var len = _this.size;
		var i = 0;
		while (i < len) {
			if (!predicate(keys[i], values[i])) {
				++i;
				continue;
			}

			--len;
			keys[i] = keys[len];
			values[i] = values[len];
			found = true;
		}

		_this.setSize(len);

		return found;
	}

	/**
		Removes all key-value pairs that match `predicate`.
		The order is preserved.

		Used for implementing `banker.linker.interfaces.Set.removeAll()`.
		@return `true` if any found and removed.
	**/
	public static inline function removeShiftAll<K, V>(
		_this: TopAlignedBuffer<K, V>,
		predicate: (key: K, value: V) -> Bool
	): Bool {
		final size = _this.size;
		final keys = _this.keyVector;
		final values = _this.valueVector;

		var found = false;
		var readIndex = 0;
		var writeIndex = 0;

		while (readIndex < size) {
			final readingKey = keys[readIndex];
			final readingValue = values[readIndex];
			++readIndex;

			if (!predicate(readingKey, readingValue)) {
				keys[writeIndex] = readingKey;
				values[writeIndex] = readingValue;
				++writeIndex;
				continue;
			}

			found = true;
		}

		_this.setSize(writeIndex);

		return found;
	}

	/**
		Removes all key-value pairs that match `predicate` and
		applies `callback` to each removed pair.
		The order is not preserved.

		Used for implementing `banker.linker.interfaces.Set.removeApplyAll()`.
		@return `true` if any found and removed.
	**/
	public static inline function removeSwapApplyAll<K, V>(
		_this: TopAlignedBuffer<K, V>,
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		final keys = _this.keyVector;
		final values = _this.valueVector;

		var found = false;
		var len = _this.size;
		var i = 0;
		while (i < len) {
			final key = keys[i];
			final value = values[i];
			if (!predicate(key, value)) {
				++i;
				continue;
			}

			--len;
			keys[i] = keys[len];
			values[i] = values[len];
			found = true;

			callback(key, value);
		}

		_this.setSize(len);

		return found;
	}

	/**
		Removes all key-value pairs that match `predicate` and
		applies `callback` to each removed pair.
		The order is preserved.

		Used for implementing `banker.linker.interfaces.Set.removeAll()`.
		@return `true` if any found and removed.
	**/
	public static inline function removeShiftApplyAll<K, V>(
		_this: TopAlignedBuffer<K, V>,
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		final size = _this.size;
		final keys = _this.keyVector;
		final values = _this.valueVector;

		var found = false;
		var readIndex = 0;
		var writeIndex = 0;

		while (readIndex < size) {
			final readingKey = keys[readIndex];
			final readingValue = values[readIndex];
			++readIndex;

			if (!predicate(readingKey, readingValue)) {
				keys[writeIndex] = readingKey;
				values[writeIndex] = readingValue;
				++writeIndex;
				continue;
			}

			callback(readingKey, readingValue);
			found = true;
		}

		_this.setSize(writeIndex);

		return found;
	}
}
