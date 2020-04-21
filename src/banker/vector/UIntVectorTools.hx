package banker.vector;

class UIntVectorTools {
	/**
		@return New vector with sequence `UInt` values.
	**/
	public static inline function createSequenceNumbers(start: UInt, end: UInt): Vector<UInt> {
		return createSequenceNumbersWritable(start, end).nonWritable();
	}

	/**
		@return New vector with sequence `UInt` values.
	**/
	public static inline function createSequenceNumbersWritable(
		start: UInt,
		end: UInt
	): WritableVector<UInt> {
		#if !macro
		assert(start <= end);
		#end
		final vector = new WritableVector<UInt>(end - start);
		var i = UInt.zero;
		var n = start;
		while (n < end) {
			vector[i] = n;
			++i;
			++n;
		}
		return vector;
	}

	/**
		Assigns sequence numbers to `vector` starting at index `0`.
		@param start The first value of sequence numbers.
	**/
	public static inline function assignSequenceNumbers(
		vector: WritableVector<UInt>,
		start: UInt
	): Void {
		final len = vector.length;
		var i = UInt.zero;
		var n = start;
		while (i < len) {
			vector[i] = n;
			++i;
			++n;
		}
	}

	/**
		Writes an inverse mapping of `source` to `destination`.
		Every value of `source` should be unique within the index range (`0` to `rangeLength`).
	**/
	public static inline function blitInverse(
		source: VectorReference<UInt>,
		destination: WritableVector<UInt>,
		rangeLength: UInt
	): Void {
		#if !macro
		assert(rangeLength <= source.length && rangeLength <= destination.length);
		#end
		var i = UInt.zero;
		while (i < rangeLength) {
			destination[source[i]] = i;
			++i;
		}
	}
}
