package banker.container.buffer.top_aligned;

import banker.container.ArrayList;

class CloneExtension {
	/**
		@return Shallow copy of `this` as a `Vector`.
	**/
	public static inline function export<T>(_this: TopAlignedBuffer<T>): Vector<T> {
		return _this.vector.ref.slice(UInt.zero, _this.size);
	}

	/**
		@return Shallow copy of `this` as a `WritableVector`.
	**/
	public static inline function exportWritable<T>(
		_this: TopAlignedBuffer<T>
	): WritableVector<T> {
		return _this.vector.ref.sliceWritable(UInt.zero, _this.size);
	}

	/**
		Creates a copy.

		- If `newCapacity` is `MaybeUInt.none`,
			the new container has the same capacity as `this`.
		- If `newCapacity` is less than the number of current elements (`this.size`),
			the overflowing data is truncated.

		@return Shallow copy of `this` as an `ArrayList`.
	**/
	public static inline function cloneAsList<T>(
		_this: TopAlignedBuffer<T>,
		newCapacity: MaybeUInt
	): ArrayList<T> {
		final newCapacityValue = if (newCapacity.isSome()) newCapacity.unwrap() else
			_this.capacity;

		final newContainer = new ArrayList<T>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}

	/**
		@return Shallow copy of `this` as an `ArrayStack`.
		@see `cloneAsList()` about the argument `newCapacity`.
	**/
	public static inline function cloneAsStack<T>(
		_this: TopAlignedBuffer<T>,
		newCapacity: MaybeUInt
	): ArrayStack<T> {
		final newCapacityValue = if (newCapacity.isSome()) newCapacity.unwrap() else
			_this.capacity;
		final newContainer = new ArrayStack<T>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}

	/**
		@return Shallow copy of `this` as an `ArrayMultiset`.
		@see `cloneAsList()` about the argument `newCapacity`.
	**/
	public static inline function cloneAsMultiset<T>(
		_this: TopAlignedBuffer<T>,
		newCapacity: MaybeUInt
	): ArrayMultiset<T> {
		final newCapacityValue = if (newCapacity.isSome()) newCapacity.unwrap() else
			_this.capacity;
		final newContainer = new ArrayMultiset<T>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}

	/**
		@param _this Must consist of unique elements.
		@return Shallow copy of `this` as an `ArraySet`.
		@see `cloneAsList()` about the argument `newCapacity`.
	**/
	public static inline function cloneAsSet<T>(
		_this: TopAlignedBuffer<T>,
		newCapacity: MaybeUInt
	): ArraySet<T> {
		final newCapacityValue = if (newCapacity.isSome()) newCapacity.unwrap() else
			_this.capacity;
		final newContainer = new ArraySet<T>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}
}
