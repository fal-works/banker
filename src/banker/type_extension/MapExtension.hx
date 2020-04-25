package banker.type_extension;

class MapExtension {
	/**
		Alias for `exists()`.
	**/
	public static inline function hasKey<K, V>(_this: Map<K, V>, key: K)
		return _this.exists(key);

	/**
		@return
			The value mapped from `key`.
			If not found, `value` (without setting to `this`).
	**/
	public static inline function getOr<K, V>(
		_this: Map<K, V>,
		key: K,
		defaultValue: V
	) {
		return Nulls.coalesce(_this.get(key), defaultValue);
	}

	/**
		@return
			The value mapped from `key`.
			If not found, `value` (also setting a new `key`-`value` pair to `this`).
	**/
	public static inline function getOrAdd<K, V>(
		_this: Map<K, V>,
		key: K,
		value: V
	) {
		final currentValue = _this.get(key);

		return if (currentValue != null) {
			currentValue;
		} else {
			_this.set(key, value);
			return value;
		}
	}

	/**
		Applies `callback` to the value mapped from `key`.
		@return `true` if found and applied.
	**/
	public static inline function getApply<K, V>(
		_this: Map<K, V>,
		key: K,
		callback: (key: K, value: V) -> Void
	): Bool {
		final currentValue = _this.get(key);

		return if (currentValue != null) {
			callback(key, currentValue);
			true;
		} else {
			false;
		}
	}

	/**
		@return `K->V` function.
	**/
	public static inline function toFunction<K, V>(
		_this: Map<K, V>,
		defaultValue: V
	): (key: K) -> V {
		return key -> getOr(_this, key, defaultValue);
	}

	/**
		@param out The target map to set new entries.
		@return New map with converted values.
	**/
	public static inline function mapValues<K, V, W>(
		_this: Map<K, V>,
		out: Map<K, W>,
		convert: (value: V) -> W
	): Map<K, W> {
		for (key => value in _this)
			out.set(key, convert(value));

		return out;
	}

	/**
		Counts keys of `this`. Internally uses `keys()` iterator.
		@return The number of keys.
	**/
	public static inline function countKeys<K, V>(_this: Map<K, V>): Int {
		var i = UInt.zero;
		for (key in _this.keys()) ++i;
		return i;
	}
}
