package banker.map.buffer.top_aligned;

class ConvertExtension {
	/** @see `banker.map.interfaces.Convert` **/
	public static inline function exportKeys<K, V>(
		_this: TopAlignedBuffer<K, V>
	): Vector<K> {
		return _this.keyVector.ref.slice(UInt.zero, _this.size);
	}

	/** @see `banker.map.interfaces.Convert` **/
	public static inline function exportValues<K, V>(
		_this: TopAlignedBuffer<K, V>
	): Vector<V> {
		return _this.valueVector.ref.slice(UInt.zero, _this.size);
	}

	/** @see `banker.map.interfaces.Convert` **/
	public static inline function exportKeysWritable<K, V>(
		_this: TopAlignedBuffer<K, V>
	): WritableVector<K> {
		return _this.keyVector.ref.sliceWritable(UInt.zero, _this.size);
	}

	/** @see `banker.map.interfaces.Convert` **/
	public static inline function exportValuesWritable<K, V>(
		_this: TopAlignedBuffer<K, V>
	): WritableVector<V> {
		return _this.valueVector.ref.sliceWritable(UInt.zero, _this.size);
	}

	/**
		Overwrites `destination` with:
		- Same keys as `this`
		- Converted values from `this`

		Used for implementing `banker.map.interfaces.Convert.mapValues()`.
	**/
	public static inline function copyWithMappedValues<K, V, W>(
		_this: TopAlignedBuffer<K, V>,
		destination: TopAlignedBuffer<K, W>,
		convertValue: (key: K, value: V) -> W
	): Void {
		final size = _this.size;
		assert(size <= destination.capacity);

		final keys = _this.keyVector;
		final values = _this.valueVector;
		final newKeys = destination.keyVector;
		final newValues = destination.valueVector;

		var i = UInt.zero;
		while (i < size) {
			final key = keys[i];
			newKeys[i] = key;
			newValues[i] = convertValue(key, values[i]);
			++i;
		}

		destination.nextFreeSlotIndex = size;
	}

	/**
		Creates a copy.

		- If `newCapacity` is `MaybeUInt.none`,
			the new container has the same capacity as `this`.
		- If `newCapacity` is less than the number of current elements (`this.size`),
			the overflowing data is truncated.

		@return Shallow copy of `this` as an `ArrayMap`.
	**/
	public static inline function cloneAsMap<K, V>(
		_this: TopAlignedBuffer<K, V>,
		newCapacity: MaybeUInt
	): ArrayMap<K, V> {
		final newCapacityValue = if (newCapacity.isSome()) newCapacity.unwrap() else
			_this.capacity;
		final newContainer = new ArrayMap<K, V>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}

	/**
		@return Shallow copy of `this` as an `ArrayOrderedMap`.
		@see `cloneAsMap()` about the argument `newCapacity`.
	**/
	public static inline function cloneAsOrderedMap<K, V>(
		_this: TopAlignedBuffer<K, V>,
		newCapacity: MaybeUInt
	): ArrayOrderedMap<K, V> {
		final newCapacityValue = if (newCapacity.isSome()) newCapacity.unwrap() else
			_this.capacity;
		final newContainer = new ArrayOrderedMap<K, V>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}
}
