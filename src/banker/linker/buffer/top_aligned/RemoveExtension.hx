package banker.linker.buffer.top_aligned;

class RemoveExtension {
	/**
		Removes the key-value pair at `index` by swapping elements with that at the last index
		(hence the order is not preserved).
		O(1) complexity.
	**/
	public static inline function removeSwapAt<K, V>(_this: TopAlignedBuffer<K, V>, index: Int): Void {
		final lastIndex = _this.nextFreeSlotIndex - 1;
		_this.keyVector[index] = _this.keyVector[lastIndex];
		_this.valueVector[index] = _this.valueVector[lastIndex];
		_this.nextFreeSlotIndex = lastIndex;
	}

	/**
		Removes the first key-value pair that matches `key`.
		O(n) complexity.
		@return True if found and removed.
	**/
	public static inline function remove<K, V>(_this: TopAlignedBuffer<K, V>, key: K): Bool {
		var found = false;
		final keys = _this.keyVector;
		final values = _this.valueVector;
		var len = _this.size;
		var i = 0;
		while (i < len) {
			if (keys[i] != key) {
				++i;
				continue;
			}

			--len;
			keys[i] = keys[len];
			values[i] = values[len];
			_this.nextFreeSlotIndex = len;
			found = true;
			break;
		}

		return found;
	}

	/**
		Removes all key-value pairs that match `key`.
		@return  True if any found and removed.
	**/
	public static function removeAll<K, V>(_this: TopAlignedBuffer<K, V>, key: K): Bool {
		var found = false;
		final keys = _this.keyVector;
		final values = _this.keyVector;
		var len = _this.size;
		var i = 0;
		while (i < len) {
			if (keys[i] != key) {
				++i;
				continue;
			}

			--len;
			keys[i] = keys[len];
			values[i] = values[len];
			found = true;
		}

		_this.nextFreeSlotIndex = len;

		return found;
	}

	/**
		Removes the first key-value pair that matches `key` and returns the value.
		Be sure that `key` exists.
		O(n) complexity.
		@return The mapped value.
	**/
	public static function removeGet<K, V>(_this: TopAlignedBuffer<K, V>, key: K): V {
		final index = _this.keyVector.ref.findIndexIn(key, 0, _this.size);
		assert(index >= 0, _this.tag, "Not found.");

		final value = _this.valueVector[index];
		removeSwapAt(_this, index);
		return value;
	}

	/**
		Removes the first key-value pair that matches `key` and returns the value.
		O(n) complexity.
		@return The mapped value. Null if not found.
	**/
	public static function tryRemoveGet<K, V>(_this: TopAlignedBuffer<K, V>, key: K): Null<V> {
		final index = _this.keyVector.ref.findIndexIn(key, 0, _this.size);

		return if (index >= 0) {
			final value = _this.valueVector[index];
			removeSwapAt(_this, index);
			value;
		} else null;
	}

	/**
		Removes the first key-value pair that matches `key` and applies `callback` to the removing key-value pair.
		O(n) complexity.
	**/
	public static function removeApply<K, V>(_this: TopAlignedBuffer<K, V>, key: K, callback: K->V->Void): Void {
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
			final lastIndex = _this.nextFreeSlotIndex - 1;
			keys[i] = keys[lastIndex];
			values[i] = values[lastIndex];
			_this.nextFreeSlotIndex = lastIndex;
			break;
		}
	}
}
