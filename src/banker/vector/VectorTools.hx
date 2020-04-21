package banker.vector;

class VectorTools {
	/**
		Copies `rangeLength` of elements from `source` (beginning at `sourcePosition`)
		to `destination` (beginning at `destinationPosition`).
	**/
	public static inline function blit<T>(
		source: VectorReference<T>,
		sourcePosition: UInt,
		destination: WritableVector<T>,
		destinationPosition: UInt,
		rangeLength: UInt
	): Void {
		#if !macro
		assert(sourcePosition + rangeLength <= source.length);
		assert(destinationPosition + rangeLength <= destination.length);
		#end
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
		rangeLength: UInt
	): Void {
		#if !macro
		assert(rangeLength <= source.length);
		assert(rangeLength <= destination.length);
		#end
		destination.ref.data.blit(UInt.zero, source.data, UInt.zero, rangeLength);
	}

	/**
		Blits data from vector to array.
	**/
	public static inline function blitToArray<T>(
		sourceVector: VectorReference<T>,
		sourcePosition: UInt,
		destinationArray: Array<T>,
		destinationPosition: UInt,
		rangeLength: UInt
	): Void {
		#if !macro
		assert(sourcePosition + rangeLength <= sourceVector.length);
		assert(destinationPosition + rangeLength <= destinationArray.length);
		#end
		var i = UInt.zero;
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
		startIndex: UInt,
		endIndex: UInt
	): WritableVector<V> {
		final newVector = new WritableVector<V>(endIndex - startIndex);
		var readIndex = startIndex;
		var writeIndex = UInt.zero;
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
		startIndex: UInt,
		endIndex: UInt
	): Vector<V> {
		return zipInWritable(
			vectorA,
			vectorB,
			zipper,
			startIndex,
			endIndex
		).nonWritable();
	}

	/**
		@return New vector created by iterating two vectors simultaneously.
	**/
	public static inline function zip<T, U, V>(
		vectorA: VectorReference<T>,
		vectorB: VectorReference<U>,
		zipper: (elementA: T, elementB: U) -> V
	): Vector<V> {
		return zipIn(
			vectorA,
			vectorB,
			zipper,
			UInt.zero,
			UInts.min(vectorA.length, vectorB.length)
		);
	}

	/**
		@return New vector created by iterating two vectors simultaneously.
	**/
	public static inline function zipWritable<T, U, V>(
		vectorA: VectorReference<T>,
		vectorB: VectorReference<U>,
		zipper: (elementA: T, elementB: U) -> V
	): WritableVector<V> {
		return zipInWritable(
			vectorA,
			vectorB,
			zipper,
			UInt.zero,
			UInts.min(vectorA.length, vectorB.length)
		);
	}
}
