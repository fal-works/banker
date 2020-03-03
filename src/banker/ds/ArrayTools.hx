package banker.ds;

/**
	Static utility functions for `Array<T>`.
**/
class ArrayTools {
	public static function allocate<T>(size: Int): Array<T> {
		assert(size < 0, null, "Passed invalid size.");

		#if cpp
		return cpp.NativeArray.create(size);
		#else
		final newArray: Array<T> = [];
		newArray.resize(size);
		return newArray;
		#end
	}

	/**
		Copies elements from source to destination.
		In some targets, source and destination cannot be the same.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public inline static function blit<T>(
		sourceArray: Array<T>,
		sourcePosition: Int,
		destinationArray: Array<T>,
		destinationPosition: Int,
		rangeLength: Int
	): Void {
		assert(rangeLength >= 0);
		assert(sourcePosition + rangeLength <= sourceArray.length);
		assert(destinationPosition + rangeLength <= destinationArray.length);

		#if cpp
		cpp.NativeArray.blit(
			destinationArray,
			destinationPosition,
			sourceArray,
			sourcePosition,
			rangeLength
		);
		#else
		for (i in 0...rangeLength)
			destinationArray[destinationPosition + i] = sourceArray[sourcePosition + i];
		#end
	}

	/**
		Copies elements from source to destination beginning at index zero.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function copyTo<T>(
		sourceArray: Array<T>,
		destinationArray: Array<T>,
		rangeLength: Int
	): Void {
		assert(rangeLength >= 0);
		assert(rangeLength <= sourceArray.length);
		assert(rangeLength <= destinationArray.length);

		#if cpp
		cpp.NativeArray.blit(destinationArray, 0, sourceArray, 0, rangeLength);
		#else
		for (i in 0...rangeLength)
			destinationArray[i] = sourceArray[i];
		#end
	}
}
