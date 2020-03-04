package banker.container;

import banker.container.extension.array.StackExtension.pushFromVector;

class ContainerBuilder {
	public static inline function arrayStackFromVector<T>(vector: VectorReference<T>, capacity: Int = -1) {
		final capacityValue = if (capacity >= 0) capacity else vector.length;
		assert(vector.length <= capacityValue);

		final container = new ArrayStack<T>(capacityValue);
		pushFromVector(container, vector);
		return container;
	}

	public static inline function arrayListFromVector<T>(vector: VectorReference<T>, capacity: Int = -1) {
		final capacityValue = if (capacity >= 0) capacity else vector.length;
		assert(vector.length <= capacityValue);

		final container = new ArrayList<T>(capacityValue);
		pushFromVector(container, vector);
		return container;
	}
}
