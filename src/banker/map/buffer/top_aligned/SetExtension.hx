package banker.map.buffer.top_aligned;

class SetExtension {
	/** @see `banker.map.interfaces.Set` **/
	public static inline function hasKey<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): Bool {
		return _this.keyVector.ref.hasIn(key, UInt.zero, _this.size);
	}

	/** @see `banker.map.interfaces.Set` **/
	public static inline function hasValue<K, V>(
		_this: TopAlignedBuffer<K, V>,
		value: V
	): Bool {
		return _this.valueVector.ref.hasIn(value, UInt.zero, _this.size);
	}

	/** @see `banker.map.interfaces.Set` **/
	public static inline function hasAny<K, V>(
		_this: TopAlignedBuffer<K, V>,
		predicate: (key: K, value: V) -> Bool
	): Bool {
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final size = _this.size;

		var found = false;
		var i = UInt.zero;
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

	/** @see `banker.map.interfaces.Set` **/
	public static inline function remove<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): Bool {
		var found = false;
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final len = _this.size;
		var i = UInt.zero;
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

	/** @see `banker.map.interfaces.Set` **/
	public static inline function removeGet<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): V {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, UInt.zero, size);
		assert(index.isSome(), _this.tag, "Not found.");

		final values = _this.valueVector;
		final value = values[index.unwrap()];
		_this.removeAtInternal(keys, values, size, index.unwrap());
		return value;
	}

	/** @see `banker.map.interfaces.Set` **/
	public static inline function tryRemoveGet<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K
	): Null<V> {
		final size = _this.size;
		final keys = _this.keyVector;
		final index = keys.ref.findIndexIn(key, UInt.zero, size);

		return if (index.isSome()) {
			final values = _this.valueVector;
			final value = values[index.unwrap()];
			_this.removeAtInternal(keys, values, size, index.unwrap());
			value;
		} else null;
	}

	/** @see `banker.map.interfaces.Set` **/
	public static inline function removeApply<K, V>(
		_this: TopAlignedBuffer<K, V>,
		key: K,
		callback: K->V->Void
	): Void {
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final len = _this.size;
		var i = UInt.zero;
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

	/** @see `banker.map.interfaces.Set` **/
	public static inline function removeAll<K, V>(
		_this: TopAlignedBuffer<K, V>,
		predicate: (key: K, value: V) -> Bool
	): Bool {
		return _this.removeAllInternal(predicate);
	}

	/** @see `banker.map.interfaces.Set` **/
	public static inline function removeApplyAll<K, V>(
		_this: TopAlignedBuffer<K, V>,
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		return _this.removeApplyAllInternal(predicate, callback);
	}
}
