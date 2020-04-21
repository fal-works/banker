package banker.map.buffer.top_aligned;

class MapExtension {
	/** @see `banker.map.interfaces.Map` **/
	public static inline function get<K, V>(_this: TopAlignedBuffer<K, V>, key: K): V {
		final index = _this.keyVector.ref.findIndexIn(key, UInt.zero, _this.size);
		assert(index.isSome(), _this.tag, "Not found.");
		return _this.valueVector[index.unwrap()];
	}

	/** @see `banker.map.interfaces.Map` **/
	public static inline function getOr<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		defaultValue: V
	): V {
		final index = _this.keyVector.ref.findIndexIn(key, UInt.zero, _this.size);
		return if (index.isSome()) _this.valueVector[index.unwrap()] else defaultValue;
	}

	/** @see `banker.map.interfaces.Map` **/
	public static inline function getOrElse<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		valueFactory: () -> V
	): V {
		final index = _this.keyVector.ref.findIndexIn(key, UInt.zero, _this.size);
		return if (index.isSome()) _this.valueVector[index.unwrap()] else valueFactory();
	}

	/** @see `banker.map.interfaces.Map` **/
	public static inline function tryGet<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): Null<V> {
		final index = _this.keyVector.ref.findIndexIn(key, UInt.zero, _this.size);
		return if (index.isSome()) _this.valueVector[index.unwrap()] else null;
	}

	/** @see `banker.map.interfaces.Map` **/
	public static inline function set<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		value: V
	): Bool {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, UInt.zero, size);
		return if (index.isSome()) {
			_this.valueVector[index.unwrap()] = value;
			false;
		} else {
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, _this.valueVector, size, key, value);
			true;
		}
	}

	/** @see `banker.map.interfaces.Map` **/
	public static inline function setIfAbsent<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		value: V
	): Bool {
		final size = _this.size;
		final keys = _this.keyVector;
		return if (keys.ref.hasIn(key, UInt.zero, size)) {
			false;
		} else {
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, _this.valueVector, size, key, value);
			true;
		}
	}

	/** @see `banker.map.interfaces.Map` **/
	public static inline function setIf<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		newValue: V,
		predicate: (
			key: K,
			oldValue: V,
			newValue: V
		) -> Bool
	): Bool {
		final size = _this.size;
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final index = keys.ref.findIndexIn(key, UInt.zero, size);
		return if (index.isSome()) {
			if (predicate(key, values[index.unwrap()], newValue)) values[index.unwrap()] = newValue;
			true;
		} else {
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, values, size, key, newValue);
			false;
		}
	}

	/** @see `banker.map.interfaces.Map` **/
	public static inline function getOrAdd<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		defaultValue: V
	): V {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, UInt.zero, size);

		return if (index.isSome()) {
			_this.valueVector[index.unwrap()];
		} else {
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, _this.valueVector, size, key, defaultValue);
			defaultValue;
		}
	}

	/** @see `banker.map.interfaces.Map` **/
	public static inline function getOrAddWith<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		valueFactory: K->V
	): V {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, UInt.zero, size);

		return if (index.isSome()) {
			_this.valueVector[index.unwrap()];
		} else {
			final newValue = valueFactory(key);
			assert(size < _this.capacity, _this.tag, "The map is full.");
			_this.addKeyValue(keys, _this.valueVector, size, key, newValue);
			newValue;
		}
	}
}
