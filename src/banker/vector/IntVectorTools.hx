package banker.vector;

class IntVectorTools {
	/**
		@return New vector with sequence `Int` values.
	**/
	public static inline function createSequenceNumbers(start: Int, end: Int): Vector<Int> {
		return createSequenceNumbersWritable(start, end).nonWritable();
	}

	/**
		@return New vector with sequence `Int` values.
	**/
	public static inline function createSequenceNumbersWritable(
		start: Int,
		end: Int
	): WritableVector<Int> {
		#if !macro
		assert(start <= end);
		#end
		final vector = new WritableVector<Int>(end - start);
		var i = 0;
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
		vector: WritableVector<Int>,
		start: Int
	): Void {
		final len = vector.length;
		var i = 0;
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
		source: VectorReference<Int>,
		destination: WritableVector<Int>,
		rangeLength: Int
	): Void {
		#if !macro
		assert(rangeLength <= source.length && rangeLength <= destination.length);
		#end
		var i = 0;
		while (i < rangeLength) {
			destination[source[i]] = i;
			++i;
		}
	}
}
