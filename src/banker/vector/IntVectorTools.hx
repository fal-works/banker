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
		vector: WritableVector<Int>,
		start: Int
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
}
