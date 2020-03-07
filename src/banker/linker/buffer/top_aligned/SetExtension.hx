package banker.linker.buffer.top_aligned;

class SetExtension {
	/** @see `banker.linker.interfaces.Set` **/
	public static inline function hasKey<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): Bool {
		return _this.keyVector.ref.hasIn(key, 0, _this.size);
	}

	/** @see `banker.linker.interfaces.Set` **/
	public static inline function hasValue<K, V>(
		_this: TopAlignedBuffer<K, V>,
		value: V
	): Bool {
		return _this.valueVector.ref.hasIn(value, 0, _this.size);
	}

	/** @see `banker.linker.interfaces.Set` **/
	public static inline function hasAny<K, V>(
		_this: TopAlignedBuffer<K, V>,
		predicate: (key: K, value: V) -> Bool
	): Bool {
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final size = _this.size;

		var found = false;
		var i = 0;
		while (i < size) {
			if (!predicate(keys[i], values[i])) {
				++i;
				continue;
			}

			found = true;
			break;
		}

		return found;
	}

	/** @see `banker.linker.interfaces.Set` **/
	public static inline function remove<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): Bool {
		var found = false;
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final len = _this.size;
		var i = 0;
		while (i < len) {
			if (keys[i] != key) {
				++i;
				continue;
			}

			_this.removeAtInternal(keys, values, len, i);
			found = true;
			break;
		}

		return found;
	}

	/** @see `banker.linker.interfaces.Set` **/
	public static inline function removeGet<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): V {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, 0, size);
		assert(index >= 0, _this.tag, "Not found.");

		final values = _this.valueVector;
		final value = values[index];
		_this.removeAtInternal(keys, values, size, index);
		return value;
	}

	/** @see `banker.linker.interfaces.Set` **/
	public static inline function tryRemoveGet<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): Null<V> {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, 0, size);

		return if (index >= 0) {
			final values = _this.valueVector;
			final value = values[index];
			_this.removeAtInternal(keys, values, size, index);
			value;
		} else null;
	}

	/** @see `banker.linker.interfaces.Set` **/
	public static inline function removeApply<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		callback: K->V->Void
	): Void {
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final len = _this.size;
		var i = 0;
		while (i < len) {
			if (keys[i] != key) {
				++i;
				continue;
			}

			callback(keys[i], values[i]);
			_this.removeAtInternal(keys, values, len, i);
			break;
		}
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
