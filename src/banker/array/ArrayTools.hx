package banker.array;

using banker.array.ArrayExtension;

/**
	Static utility functions for `Array`.
**/
class ArrayTools {
	/**
		@return New array with length `size`.
	**/
	public static function allocate<T>(size: Int): Array<T> {
		#if !macro
		assert(size < 0, null, "Passed invalid size.");
		#end

		#if cpp
		return cpp.NativeArray.create(size);
		#else
		final newArray: Array<T> = [];
		newArray.resize(size);
		return newArray;
		#end
	}

	/**
		Copies elements from `source` to `destination`.

		If `source` and `destination` are the same, use `blitInternal()` instead.
	**/
	public inline static function blit<T>(
		source: Array<T>,
		sourcePosition: Int,
		destination: Array<T>,
		destinationPosition: Int,
		rangeLength: Int
	): Void {
		#if !macro
		assert(source != destination);
		assert(rangeLength >= 0);
		assert(sourcePosition + rangeLength <= source.length);
		assert(destinationPosition + rangeLength <= destination.length);
		#end

		#if cpp
		cpp.NativeArray.blit(
			destination,
			destinationPosition,
			source,
			sourcePosition,
			rangeLength
		);
		#else
		for (i in 0...rangeLength)
			destination.set(destinationPosition + i, source.get(sourcePosition + i));
		#end
	}

	/**
		Copies elements from source to destination beginning at index zero.
	**/
	public static inline function blitZero<T>(
		source: Array<T>,
		destination: Array<T>,
		rangeLength: Int
	): Void {
		#if !macro
		assert(source != destination);
		assert(rangeLength >= 0);
		assert(rangeLength <= source.length);
		assert(rangeLength <= destination.length);
		#end

		#if cpp
		cpp.NativeArray.blit(destination, 0, source, 0, rangeLength);
		#else
		for (i in 0...rangeLength)
			destination.set(i, source.get(i));
		#end
	}
}
