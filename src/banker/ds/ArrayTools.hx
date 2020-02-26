package banker.ds;

/**
 * Static utility functions for `Array<T>`.
 */
class ArrayTools {
	public static function allocate<T>(size: Int): Array<T> {
		#if safe
		if (size == 0)
			namelessWarning('Allocated zero size array.');
		if (size < 0)
			throw namelessError('Invalid size: ${size}');
		#end

		#if cpp
		return cpp.NativeArray.create(size);
		#else
		final newArray = [];
		newArray.resize(size);
		return newArray;
		#end
	}

	/**
	 * Copies elements from source to destination.
	 * In some targets, source and destination cannot be the same.
	 * @return The destination array.
	 */
	@:generic
	public inline static function blit<T>(
		sourceArray: Array<T>,
		sourcePosition: Int,
		destinationArray: Array<T>,
		destinationPosition: Int,
		rangeLength: Int
	): Array<T> {
		#if safe
		if (sourceArray.isNull() || destinationArray.isNull())
			throw namelessError('Passed null.');
		if (rangeLength == 0)
			namelessWarning('Passed range length zero.');
		if (rangeLength < 0)
			throw namelessError('Invalid range length: ${rangeLength}');
		if (sourcePosition + rangeLength > sourceArray.length)
			throw namelessError('Invalid range length: ${rangeLength}');
		if (destinationPosition + rangeLength > destinationArray.length)
			throw namelessError('Invalid range length: ${rangeLength}');
		#end

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

		return destinationArray;
	}

	/**
	 * Copies elements from source to destination beginning at index zero.
	 * @return The destination array.
	 */
	@:generic
	public static inline function copyTo<T>(
		sourceArray: Array<T>,
		destinationArray: Array<T>,
		rangeLength: Int
	): Array<T> {
		#if safe
		sourceArray.sure("Passed null: sourceArray");
		destinationArray.sure("Passed null: sourceArray");
		if (rangeLength <= 0)
			namelessError('Invalid range length: ${rangeLength}');
		if (rangeLength > sourceArray.length)
			throw "ArrayTools.copyTo(): rangeLength "
				+ rangeLength
				+ " is longer than the source array length "
				+ sourceArray.length
				+ ".";
		if (rangeLength > destinationArray.length)
			throw "ArrayTools.copyTo(): rangeLength "
				+ rangeLength
				+ " is longer than the destination array length "
				+ destinationArray.length
				+ ".";
		#end

		#if cpp
		cpp.NativeArray.blit(destinationArray, 0, sourceArray, 0, rangeLength);
		#elseif java
		java.lang.System.arraycopy(
			sourceArray,
			0,
			destinationArray,
			0,
			rangeLength
		);
		#else
		for (i in 0...rangeLength)
			destinationArray[i] = sourceArray[i];
		#end

		return destinationArray;
	}
}
