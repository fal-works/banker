package banker.ds;

import banker.ds.WritableVector.writable;

class WritableVectorExtension {
	public static inline function concat<T>(vector:WritableVector<T>, otherVector:Vector<T>):WritableVector<T>
		return writable(VectorExtension.concat(vector, otherVector));
}
