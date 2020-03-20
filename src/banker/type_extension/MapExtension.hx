package banker.type_extension;

using banker.type_extension.NullableExtension;

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
		return _this.get(key).or(defaultValue);
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

		return if (currentValue.exists()) {
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

		return if (currentValue.exists()) {
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
}
