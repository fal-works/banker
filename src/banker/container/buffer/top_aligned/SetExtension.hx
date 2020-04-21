package banker.container.buffer.top_aligned;

import banker.map.ArrayMap;

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
		var i = UInt.zero;
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
		var i = UInt.zero;
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
	public static inline function removeAll<T>(
		_this: TopAlignedBuffer<T>,
		predicate: (element: T) -> Bool
	): Bool {
		return _this.removeAllInternal(predicate);
	}

	/** @see `banker.container.interfaces.Set` **/
	public static inline function has<T>(_this: TopAlignedBuffer<T>, element: T): Bool {
		final size = _this.nextFreeSlotIndex;
		final vector = _this.vector;

		var found = false;
		var i = UInt.zero;
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
		var i = UInt.zero;
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

	/** @see `banker.container.interfaces.Set` **/
	public static inline function count<T>(
		_this: TopAlignedBuffer<T>,
		predicate: (element: T) -> Bool
	): Int {
		final size = _this.size;
		final vector = _this.vector;
		var count = UInt.zero;
		var i = UInt.zero;
		while (i < size) {
			if (predicate(vector[i])) ++count;
			++i;
		}
		return count;
	}

	/** @see `banker.container.interfaces.Set` **/
	public static inline function countAll<T, S>(
		_this: TopAlignedBuffer<T>,
		grouperCallback: (element: T) -> S
	): ArrayMap<S, Int> {
		final size = _this.size;
		final vector = _this.vector;
		final populationMap = new ArrayMap<S, Int>(size);
		var i = UInt.zero;
		while (i < size) {
			final group = grouperCallback(vector[i]);
			populationMap.set(group, populationMap.getOr(group, 0) + 1);
			++i;
		}
		return populationMap;
	}
}
