package banker.ds.array;

class ArrayExtension {
	public static inline function get<T>(array: Array<T>, index: Int): T {
		assert(index >= 0 && index < array.length, null, "Out of bound.");

		#if cpp
		return cpp.NativeArray.unsafeGet(array, index);
		#else
		return array[index];
		#end
	}

	public static inline function set<T>(
		array: Array<T>,
		index: Int,
		value: T
	): Void {
		assert(index >= 0 && index < array.length, null, "Out of bound.");

		#if cpp
		cpp.NativeArray.unsafeSet(array, index, value);
		#else
		array[index] = value;
		#end
	}

	public static inline function getLast<T>(array: Array<T>): T {
		#if cpp
		return cpp.NativeArray.unsafeGet(array, array.length - 1);
		#else
		return array[array.length - 1];
		#end
	}

	public static inline function fillIn<T>(
		array: Array<T>,
		value: T,
		startIndex: Int,
		endIndex: Int
	): Array<T> {
		assert(startIndex >= 0 && endIndex < array.length);

		var i = startIndex;
		while (i < endIndex) {
			set(array, i, value);
			++i;
		}

		return array;
	}

	public static inline function fill<T>(array: Array<T>, value: T): Array<T> {
		return fillIn(array, value, 0, array.length);
	}

	/**
		Copies elements from source to destination position within a same array.
		@param   array
		@param   sourcePosition
		@param   destinationPosition
		@param   rangeLength - Number of elements to copy.
		@return  Array<T> - The given array.
	**/
	#if (!cpp && !banker_generic_disable)
	@:generic
	#end
	public static #if cpp inline #end function blitInternal<T>(
		array: Array<T>,
		sourcePosition: Int,
		destinationPosition: Int,
		rangeLength: Int
	): Array<T> {
		assert(sourcePosition + rangeLength <= array.length);
		assert(destinationPosition + rangeLength <= array.length);

		#if cpp
		cpp.NativeArray.blit(
			array,
			destinationPosition,
			array,
			sourcePosition,
			rangeLength
		);
		#else
		if (sourcePosition < destinationPosition) {
			var i = sourcePosition + rangeLength;
			var k = destinationPosition + rangeLength;

			while (i > sourcePosition) {
				--i;
				--k;
				array[k] = array[i];
			}
		} else if (sourcePosition > destinationPosition) {
			var i = sourcePosition;
			var k = destinationPosition;
			final endI = sourcePosition + rangeLength;

			while (i < endI) {
				array[k] = array[i];
				++i;
				++k;
			}
		}
		#end

		return array;
	}

	/**
		Checks if the array contains the element.
		@param   array
		@param   value
		@return  True if the element is contained.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function has<T>(array: Array<T>, value: T): Bool {
		final len = array.length;
		var found = false;
		var i = 0;
		while (i < len) {
			if (value == get(array, i)) {
				found = true;
				break;
			}
			++i;
		}

		return found;
	}

	#if !banker_generic_disable
	@:generic
	#end
	public static inline function swap<T>(
		array: Array<T>,
		indexA: Int,
		indexB: Int
	): Void {
		assert(indexA >= 0 && indexA < array.length);
		assert(indexB >= 0 && indexB < array.length);

		var tmp = get(array, indexA);
		set(array, indexA, get(array, indexB));
		set(array, indexB, tmp);
	}
}
