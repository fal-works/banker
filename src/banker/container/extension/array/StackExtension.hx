package banker.container.extension.array;

class StackExtension {
	/**
		Adds `element` as the last (newest) element of `this`.
		Duplicates are allowed.
	**/
	public static inline function push<T>(_this: ArrayBase<T>, element: T): Void {
		final index = _this.nextFreeSlotIndex;
		assert(index < _this.capacity, _this.tag, "The list is full.");

		_this.nextFreeSlotIndex = index + 1;

		_this.vector[index] = element;

		#if banker_watermark_enable
		updateWatermark(getUsageRatio()); // Currently does not work
		#end
	}

	/**
		Removes the last (newest) element.
		@return Removed element.
	**/
	public static inline function pop<T>(_this: ArrayBase<T>): T {
		final index = _this.nextFreeSlotIndex - 1;
		assert(index >= 0, _this.tag, "The list is empty.");

		_this.nextFreeSlotIndex = index;

		return _this.vector[index];
	}

	/**
		@return The last (newest) element.
	**/
	public static inline function peek<T>(_this: ArrayBase<T>): T {
		final index = _this.nextFreeSlotIndex - 1;
		assert(index >= 0, _this.tag, "The list is empty.");

		return _this.vector[index];
	}

	/**
		Adds all elements in `vector` as the last (newest) elements of `this`.
		Duplicates are allowed.
	**/
	public static inline function pushFromVector<T>(_this: ArrayBase<T>, vector: VectorReference<T>): Void {
		final index = _this.nextFreeSlotIndex;
		final increment = vector.length;
		assert(index + increment <= _this.capacity, _this.tag, "Not enough space.");

		VectorTools.blit(vector, 0, _this.vector, index, increment);
		_this.nextFreeSlotIndex = index + increment;

		#if banker_watermark_enable
		updateWatermark(getUsageRatio()); // Currently does not work
		#end
	}
}
