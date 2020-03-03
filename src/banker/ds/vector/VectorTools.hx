package banker.ds.vector;

class VectorTools {
	/**
		Static version of `blit()`.
		Copies `rangeLength` of elements from `source` (beginning at `sourcePosition`)
		to `destination` (beginning at `destinationPosition`).
	**/
	public static inline function blit<T>(
		source: VectorReference<T>,
		sourcePosition: Int,
		destination: WritableVector<T>,
		destinationPosition: Int,
		rangeLength: Int
	): Void {
		assert(sourcePosition >= 0 && destinationPosition >= 0);
		assert(sourcePosition + rangeLength <= source.length);
		assert(destinationPosition + rangeLength <= destination.length);
		destination.data.blit(
			destinationPosition,
			source.writable().data,
			sourcePosition,
			rangeLength
		);
	}

	/**
		Blits data from vector to array.
	**/
	public static inline function blitToArray<T>(
		sourceVector: VectorReference<T>,
		sourcePosition: Int,
		destinationArray: Array<T>,
		destinationPosition: Int,
		rangeLength: Int
	): Void {
		assert(sourcePosition >= 0 && destinationPosition >= 0);
		assert(sourcePosition + rangeLength <= sourceVector.length);
		assert(destinationPosition + rangeLength <= destinationArray.length);
		var i = 0;
		while (i < rangeLength) {
			destinationArray[destinationPosition + i] = sourceVector[sourcePosition + i];
			++i;
		}
	}
}
