package banker.ds;

class VectorExtension {
	/**
	 * Returns a new concatenated vector.
	 */
	 public static inline function concat<T>(vector:Vector<T>, otherVector:Vector<T>):Vector<T> {
		final thisLength = vector.length;
		final otherLength = otherVector.length;
		final newVector = new Vector(thisLength + otherLength);
		NaiveVector.blit(vector.data, 0, newVector.data, 0, thisLength);
		NaiveVector.blit(otherVector.data, 0, newVector.data, thisLength, otherLength);

		return newVector;
	}
}
