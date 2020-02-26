package banker.ds;

import banker.ds.Vector.VectorData;
import banker.ds.WritableVector.writable;

class WritableVectorTools {
	public static inline function fromData<T>(data: VectorData<T>): WritableVector<T>
		return writable(VectorTools.fromData(data));

	public static inline function fromArrayCopy<T>(array: Array<T>): WritableVector<T>
		return writable(VectorTools.fromArrayCopy(array));

	public static inline function createFilled<T>(length: Int, fillValue: T): Vector<T>
		return writable(VectorTools.createFilled(length, fillValue));

	public static inline function createPopulated<T>(
		length: Int,
		factory: Void->T
	): Vector<T>
		return writable(VectorTools.createPopulated(length, factory));
}
