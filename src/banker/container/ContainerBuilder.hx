package banker.container;

import banker.container.buffer.top_aligned.StackExtension as TopAlignedStackExtension;

class ContainerBuilder {
	/**
		Creates an `ArrayStack` instance by copying data from `vector`.
		@param capacity Max number of elements that can be contained.
				If negative (default), the capacity will be the same as `vector.length`.
	**/
	public static inline function arrayStackFromVector<T>(
		vector: VectorReference<T>,
		capacity: Int = -1
	) {
		final capacityValue = if (capacity >= 0) capacity else vector.length;
		assert(vector.length <= capacityValue);

		final container = new ArrayStack<T>(capacityValue);
		TopAlignedStackExtension.pushFromVector(container, vector);
		return container;
	}

	/**
		Creates an `ArrayList` instance by copying data from `vector`.
		@param capacity Max number of elements that can be contained.
				If negative (default), the capacity will be the same as `vector.length`.
	**/
	public static inline function arrayListFromVector<T>(
		vector: VectorReference<T>,
		capacity: Int = -1
	) {
		final capacityValue = if (capacity >= 0) capacity else vector.length;
		assert(vector.length <= capacityValue);

		final container = new ArrayList<T>(capacityValue);
		TopAlignedStackExtension.pushFromVector(container, vector);
		return container;
	}
}
