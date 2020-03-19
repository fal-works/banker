package banker.vector;

import banker.common.MathTools.minInt;

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
		destination.ref.data.blit(
			destinationPosition,
			source.data,
			sourcePosition,
			rangeLength
		);
	}

	/**
		Copies `rangeLength` of elements from `source` to `destination`,
		both beginning at the position of index `0`.
	**/
	public static inline function blitZero<T>(
		source: VectorReference<T>,
		destination: WritableVector<T>,
		rangeLength: Int
	): Void {
		assert(rangeLength <= source.length);
		assert(rangeLength <= destination.length);
		destination.ref.data.blit(0, source.data, 0, rangeLength);
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

	/**
		@return New vector created by iterating two vectors simultaneously.
	**/
	public static inline function zipInWritable<T, U, V>(
		vectorA: VectorReference<T>,
		vectorB: VectorReference<U>,
		zipper: (elementA: T, elementB: U) -> V,
		startIndex: Int,
		endIndex: Int
	): WritableVector<V> {
		final newVector = new WritableVector<V>(endIndex - startIndex);
		var readIndex = startIndex;
		var writeIndex = 0;
		while (readIndex < endIndex) {
			newVector[writeIndex] = zipper(vectorA[readIndex], vectorB[readIndex]);
			++readIndex;
			++writeIndex;
		}

		return newVector;
	}

	/**
		@return New vector created by iterating two vectors simultaneously.
	**/
	public static inline function zipIn<T, U, V>(
		vectorA: VectorReference<T>,
		vectorB: VectorReference<U>,
		zipper: (elementA: T, elementB: U) -> V,
		startIndex: Int,
		endIndex: Int
	): Vector<V> {
		return zipInWritable(vectorA, vectorB, zipper, startIndex, endIndex).nonWritable();
	}

	/**
		@return New vector created by iterating two vectors simultaneously.
	**/
	public static inline function zip<T, U, V>(
		vectorA: VectorReference<T>,
		vectorB: VectorReference<U>,
		zipper: (elementA: T, elementB: U) -> V
	): Vector<V> {
		return zipIn(vectorA, vectorB, zipper, 0, minInt(vectorA.length, vectorB.length));
	}

	/**
		@return New vector created by iterating two vectors simultaneously.
	**/
	public static inline function zipWritable<T, U, V>(
		vectorA: VectorReference<T>,
		vectorB: VectorReference<U>,
		zipper: (elementA: T, elementB: U) -> V
	): WritableVector<V> {
		return zipInWritable(vectorA, vectorB, zipper, 0, minInt(vectorA.length, vectorB.length));
	}
}
