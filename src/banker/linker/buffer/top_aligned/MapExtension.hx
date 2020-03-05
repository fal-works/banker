package banker.linker.buffer.top_aligned;

class MapExtension {
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
		Adds a new key-value pair. Duplicate keys are allowed.
	**/
	public static inline function add<K, V>(_this: TopAlignedBuffer<K, V>, key: K, value: V): Void {
		final size = _this.size;
		assert(size < _this.capacity, _this.tag, "The map is full.");

		_this.keyVector[size] = key;
		_this.valueVector[size] = value;
		_this.nextFreeSlotIndex = size + 1;

		#if banker_watermark_enable
		updateWatermark(usage()); // Currently does not work
		#end
	}

	/**
		Maps `key` to `value`.
		If `key` already exists, the mapped value is overwritten.
		If not, adds a new key-value pair.
		@return  true if it is the first time that `key` is added.
	**/
	public static function set<K, V>(_this: TopAlignedBuffer<K, V>, key: K, value: V): Bool {
		final index = _this.keyVector.ref.findIndexIn(key, 0, _this.size);
		return if (index >= 0) {
			_this.valueVector[index] = value;
			false;
		} else {
			assert(_this.size < _this.capacity, _this.tag, "The map is full.");
			add(_this, key, value);
			true;
		}
	}

	/**
		Maps `key` to `value` only if `key` does not exist.
		@return  true if it is the first time that `key` is added.
	**/
	public static function setIfAbsent<K, V>(_this: TopAlignedBuffer<K, V>, key: K, value: V): Bool {
		return if (_this.keyVector.ref.hasIn(key, 0, _this.size)) {
			false;
		} else {
			assert(_this.size < _this.capacity, _this.tag, "The map is full.");
			add(_this, key, value);
			true;
		}
	}

	/**
		Returns the value that is mapped to `key`.
		If not found, adds a new pair of `key` and `defaultValue`, and returns `defaultValue`.
	**/
	public static inline function getOrAdd<K, V>(_this: TopAlignedBuffer<K, V>, key: K, defaultValue: V): V {
		final index = _this.keyVector.ref.findIndexIn(key, 0, _this.size);

		return if (index >= 0) {
			_this.valueVector[index];
		} else {
			add(_this, key, defaultValue);
			defaultValue;
		}
	}

	/**
		Returns the value that is mapped to `key`.
		If not found, creates new value with `valueFactory`,
		adds the new key-value pair and returns the created value.
	**/
	public static inline function getOrAddWith<K, V>(_this: TopAlignedBuffer<K, V>, key: K, valueFactory: K->V): V {
		final index = _this.keyVector.ref.findIndexIn(key, 0, _this.size);

		return if (index >= 0) {
			_this.valueVector[index];
		} else {
			final newValue = valueFactory(key);
			add(_this, key, newValue);

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
