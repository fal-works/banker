package banker.container.buffer.top_aligned;

class SetExtension {
	/** @see `banker.container.interfaces.Set` **/
	public static inline function findFirst<T>(
		_this: TopAlignedBuffer<T>,
		predicate: (element: T) -> Bool,
		defaultValue: T
	): T {
		final size = _this.size;
		final vector = _this.vector;

		var found = defaultValue;
		var i = 0;
		while (i < size) {
			final element = vector[i];
			if (!predicate(element)) {
				++i;
				continue;
			}

			found = element;
			break;
		}

		return found;
	}

	/** @see `banker.container.interfaces.Set` **/
	public static inline function remove<T>(_this: TopAlignedBuffer<T>, element: T): Bool {
		final size = _this.nextFreeSlotIndex;
		final vector = _this.vector;

		var found = false;
		var i = 0;
		while (i < size) {
			if (vector[i] != element) {
				++i;
				continue;
			}

			_this.removeAtInternal(vector, size, i);
			found = true;
			break;
		}

		return found;
	}

	/**
		Removes all elements that match `predicate`.
		The order is not preserved.

		Used for implementing `banker.container.interfaces.Set.removeAll()`.
		@return `true` if any found and removed.
	**/
	public static inline function removeSwapAll<T>(
		_this: TopAlignedBuffer<T>,
		predicate: (element: T) -> Bool
	): Bool {
		final vector = _this.vector;

		var found = false;
		var len = _this.size;
		var i = 0;
		while (i < len) {
			if (!predicate(vector[i])) {
				++i;
				continue;
			}

			--len;
			vector[i] = vector[len];
			found = true;
		}

		_this.nextFreeSlotIndex = len;

		return found;
	}

	/**
		Removes all elements that match `predicate`.
		The order is preserved.

		Used for implementing `banker.container.interfaces.Set.removeAll()`.
		@return `true` if any found and removed.
	**/
	public static inline function removeShiftAll<T>(
		_this: TopAlignedBuffer<T>,
		predicate: (element: T) -> Bool
	): Bool {
		final size = _this.size;
		final vector = _this.vector;

		var found = false;
		var readIndex = 0;
		var writeIndex = 0;

		while (readIndex < size) {
			final readingElement = vector[readIndex];
			++readIndex;

			if (!predicate(readingElement)) {
				vector[writeIndex] = readingElement;
				++writeIndex;
				continue;
			}

			found = true;
		}

		_this.nextFreeSlotIndex = writeIndex;

		return found;
	}

	/** @see `banker.container.interfaces.Set` **/
	public static inline function has<T>(_this: TopAlignedBuffer<T>, element: T): Bool {
		final size = _this.nextFreeSlotIndex;
		final vector = _this.vector;

		var found = false;
		var i = 0;
		while (i < size) {
			if (vector[i] != element) {
				++i;
				continue;
			}

			found = true;
			break;
		}

		return found;
	}

	/** @see `banker.container.interfaces.Set` **/
	public static inline function hasAny<T>(
		_this: TopAlignedBuffer<T>,
		predicate: (element: T) -> Bool
	): Bool {
		final size = _this.nextFreeSlotIndex;
		final vector = _this.vector;

		var found = false;
		var i = 0;
		while (i < size) {
			if (!predicate(vector[i])) {
				++i;
				continue;
			}

			found = true;
			break;
		}

		return found;
	}
}
