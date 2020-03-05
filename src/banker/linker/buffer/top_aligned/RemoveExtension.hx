package banker.linker.buffer.top_aligned;

class RemoveExtension {
	/**
		Removes the first key-value pair that matches `key`.
		O(n) complexity.
		@return True if found and removed.
	**/
	public static inline function remove<K, V>(_this: TopAlignedBuffer<K, V>, key: K): Bool {
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

			_this.removeAt(keys, values, len, i);
			found = true;
			break;
		}

		return found;
	}

	/**
		Removes all key-value pairs that match `key`.
		@return `true` if any found and removed.
	**/
	public static function removeSwapAll<K, V>(_this: TopAlignedBuffer<K, V>, key: K): Bool {
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
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, 0, size);
		assert(index >= 0, _this.tag, "Not found.");

		final values = _this.valueVector;
		final value = values[index];
		_this.removeAt(keys, values, size, index);
		return value;
	}

	/**
		Removes the first key-value pair that matches `key` and returns the value.
		O(n) complexity.
		@return The mapped value. Null if not found.
	**/
	public static function tryRemoveGet<K, V>(_this: TopAlignedBuffer<K, V>, key: K): Null<V> {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, 0, size);

		return if (index >= 0) {
			final values = _this.valueVector;
			final value = values[index];
			_this.removeAt(keys, values, size, index);
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
			_this.removeAt(keys, values, len, i);
			break;
		}
	}
}
