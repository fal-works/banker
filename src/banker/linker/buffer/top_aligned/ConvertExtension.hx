package banker.linker.buffer.top_aligned;

class ConvertExtension {
	/** @see `banker.linker.interfaces.Convert` **/
	public static inline function exportKeys<K, V>(
		_this: TopAlignedBuffer<K, V>
	): Vector<K> {
		return _this.keyVector.ref.slice(0, _this.size);
	}

	/** @see `banker.linker.interfaces.Convert` **/
	public static inline function exportValues<K, V>(
		_this: TopAlignedBuffer<K, V>
	): Vector<V> {
		return _this.valueVector.ref.slice(0, _this.size);
	}

	/**
		Overwrites `destination` with:
		- Same keys as `this`
		- Converted values from `this`

		Used for implementing `banker.linker.interfaces.Convert.mapValues()`.
	**/
	public static inline function copyWithMappedValues<K, V, W>(
		_this: TopAlignedBuffer<K, V>,
		destination: TopAlignedBuffer<K, W>,
		convertValue: V->W
	): Void {
		final size = _this.size;
		assert(size < destination.capacity);

		final keys = _this.keyVector;
		final values = _this.valueVector;
		final newKeys = destination.keyVector;
		final newValues = destination.valueVector;

		var i = 0;
		while (i < size) {
			newKeys[i] = keys[i];
			newValues[i] = convertValue(values[i]);
			++i;
		}

		destination.nextFreeSlotIndex = size;
	}

	/**
		Creates a copy.

		- If `newCapacity` is negative,
			the new container has the same capacity as `this`.
		- If `newCapacity` is less than the number of current elements (`this.size`),
			the overflowing data is truncated.

		@return Shallow copy of `this` as an `ArrayMap`.
	**/
	public static inline function cloneAsMap<K, V>(
		_this: TopAlignedBuffer<K, V>,
		newCapacity: Int
	): ArrayMap<K, V> {
		final newCapacityValue = if (newCapacity < 0) _this.capacity else newCapacity;
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
		newCapacity: Int
	): ArrayOrderedMap<K, V> {
		final newCapacityValue = if (newCapacity < 0) _this.capacity else newCapacity;
		final newContainer = new ArrayOrderedMap<K, V>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}
}
