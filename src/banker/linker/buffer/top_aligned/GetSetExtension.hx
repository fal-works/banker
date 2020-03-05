package banker.linker.buffer.top_aligned;

class GetSetExtension {
	/**
		Gets value for `key`. Be sure that `key` exists.
		@return The value that is mapped to `key`.
	**/
	public static inline function get<K, V>(_this: TopAlignedBuffer<K, V>, key: K): V {
		final index = _this.keyVector.ref.findIndexIn(key, 0, _this.size);
		assert(index >= 0, _this.tag, "Not found.");
		return _this.valueVector[index];
	}

	/**
		Gets value for `key`.
		@return The value that is mapped to `key`. `null` if `key` does not exist.
	**/
	public static inline function tryGet<K, V>(_this: TopAlignedBuffer<K, V>, key: K): Null<V> {
		final index = _this.keyVector.ref.findIndexIn(key, 0, _this.size);
		return if (index >= 0) _this.valueVector[index] else null;
	}

	/**
		Maps `key` to `value`.
		If `key` already exists, the mapped value is overwritten.
		If not, adds a new key-value pair.
		@return  true if it is the first time that `key` is added.
	**/
	public static function set<K, V>(_this: TopAlignedBuffer<K, V>, key: K, value: V): Bool {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, 0, _this.size);
		return if (index >= 0) {
			_this.valueVector[index] = value;
			false;
		} else {
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, _this.valueVector, size, key, value);
			true;
		}
	}

	/**
		Maps `key` to `value` only if `key` does not exist.
		@return  true if it is the first time that `key` is added.
	**/
	public static function setIfAbsent<K, V>(_this: TopAlignedBuffer<K, V>, key: K, value: V): Bool {
		final size = _this.size;
		final keys = _this.keyVector;
		return if (keys.ref.hasIn(key, 0, size)) {
			false;
		} else {
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, _this.valueVector, size, key, value);
			true;
		}
	}

	/**
		Returns the value that is mapped to `key`.
		If not found, adds a new pair of `key` and `defaultValue`, and returns `defaultValue`.
	**/
	public static inline function getOrAdd<K, V>(_this: TopAlignedBuffer<K, V>, key: K, defaultValue: V): V {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, 0, size);

		return if (index >= 0) {
			_this.valueVector[index];
		} else {
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, _this.valueVector, size, key, defaultValue);
			defaultValue;
		}
	}

	/**
		Returns the value that is mapped to `key`.
		If not found, creates new value with `valueFactory`,
		adds the new key-value pair and returns the created value.
	**/
	public static inline function getOrAddWith<K, V>(_this: TopAlignedBuffer<K, V>, key: K, valueFactory: K->V): V {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, 0, size);

		return if (index >= 0) {
			_this.valueVector[index];
		} else {
			final newValue = valueFactory(key);
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, _this.valueVector, size, key, newValue);
			newValue;
		}
	}

	/**
		Checks if `this` has `key`.
		O(n) complexity.
		@return `true` if found.
	**/
	public static inline function hasKey<K, V>(_this: TopAlignedBuffer<K, V>, key: K): Bool {
		return _this.keyVector.ref.hasIn(key, 0, _this.size);
	}
}
