package banker.container.buffer.top_aligned;

import banker.container.ArrayList;

class CloneExtension {
	/**
		Creates a copy.

		- If `newCapacity` is negative,
		  the new container has the same capacity as `this`.
		- If `newCapacity` is less than the number of current elements (`this.size`),
		  the overflowing data is truncated.

		@return Shallow copy of `this` as an `ArrayList`.
	**/
	public static inline function cloneAsList<T>(
		_this: TopAlignedBuffer<T>,
		newCapacity: Int
	): ArrayList<T> {
		final newCapacityValue = if (newCapacity < 0) _this.capacity else newCapacity;
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
		newCapacity: Int
	): ArrayStack<T> {
		final newCapacityValue = if (newCapacity < 0) _this.capacity else newCapacity;
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
		newCapacity: Int
	): ArrayMultiset<T> {
		final newCapacityValue = if (newCapacity < 0) _this.capacity else newCapacity;
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
		newCapacity: Int
	): ArraySet<T> {
		final newCapacityValue = if (newCapacity < 0) _this.capacity else newCapacity;
		final newContainer = new ArraySet<T>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}
}
