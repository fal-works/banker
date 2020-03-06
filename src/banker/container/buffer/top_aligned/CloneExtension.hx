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
		@return Shallow copy of `this` as an `ArrayMultiSet`.
		@see `cloneAsList()` about the argument `newCapacity`.
	**/
	public static inline function cloneAsMultiSet<T>(
		_this: TopAlignedBuffer<T>,
		newCapacity: Int
	): ArrayMultiSet<T> {
		final newCapacityValue = if (newCapacity < 0) _this.capacity else newCapacity;
		final newContainer = new ArrayMultiSet<T>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}

	/**
		@return Shallow copy of `this` as an `ArraySet`.
		@see `cloneAsList()` about the argument `newCapacity`.
	**/
	public static inline function cloneAsSet<T>(
		_this: ArraySet<T>,
		newCapacity: Int
	): ArraySet<T> {
		/*
			Theoretically _this can be any instance that extends
			TopAlignedBuffer and consitsts of unique elements.
		*/

		final newCapacityValue = if (newCapacity < 0) _this.capacity else newCapacity;
		final newContainer = new ArraySet<T>(newCapacityValue);
		newContainer.blitAllFrom(_this);
		return newContainer;
	}
}
