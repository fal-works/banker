package banker.container.buffer.top_aligned;

class SetExtension {
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
}
