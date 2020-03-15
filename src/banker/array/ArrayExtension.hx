package banker.array;

class ArrayExtension {
	public static inline function get<T>(array: Array<T>, index: Int): T {
		#if !macro
		assert(index >= 0 && index < array.length, null, "Out of bound.");
		#end

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
		#if !macro
		assert(index >= 0 && index < array.length, null, "Out of bound.");
		#end

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
		#if !macro
		assert(startIndex >= 0 && endIndex < array.length);
		#end

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
		#if !macro
		assert(sourcePosition + rangeLength <= array.length);
		assert(destinationPosition + rangeLength <= array.length);
		#end

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
		@return `true` if the array contains an element that is `element == value`.
	**/
	public static inline function has<T>(array: Array<T>, value: T): Bool {
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

	/**
		@return `true` if the array contains any element that matches `predicate`.
	**/
	public static inline function hasAny<T>(array: Array<T>, predicate: (element: T) -> Bool): Bool {
		final len = array.length;
		var found = false;
		var i = 0;
		while (i < len) {
			if (predicate(get(array, i))) {
				found = true;
				break;
			}
			++i;
		}

		return found;
	}

	public static inline function swap<T>(
		array: Array<T>,
		indexA: Int,
		indexB: Int
	): Void {
		#if !macro
		assert(indexA >= 0 && indexA < array.length);
		assert(indexB >= 0 && indexB < array.length);
		#end

		var tmp = get(array, indexA);
		set(array, indexA, get(array, indexB));
		set(array, indexB, tmp);
	}

	/**
		Compares two arrays with `==` operator.
		@return `true` if all elements are equal (including the order).
	**/
	public static inline function equals<T>(array: Array<T>, otherArray: Array<T>): Bool {
		final len = array.length;

		return if (otherArray.length != len) false; else {
			var foundDifference = false;

			for (i in 0...len) {
				if (get(array, i) == get(otherArray, i)) continue;

				foundDifference = true;
				break;
			}

			!foundDifference;
		}
	}

	/**
		Compares two arrays with `compare` callback.
		@return `true` if all elements are equal (including the order).
	**/
	public static inline function compare<T>(
		array: Array<T>,
		otherArray: Array<T>,
		compare: (a: T, b: T) -> Bool
	): Bool {
		final len = array.length;

		return if (otherArray.length != len) false; else {
			var foundDifference = false;

			for (i in 0...len) {
				if (compare(get(array, i), get(otherArray, i))) continue;

				foundDifference = true;
				break;
			}

			!foundDifference;
		}
	}

	/**
		Pushes all elements in `other` to `this` array.
	**/
	public static inline function pushFromArray<T>(
		_this: Array<T>,
		other: Array<T>
	): Void {
		var writeIndex = _this.length;
		var readIndex = 0;

		final otherLength = other.length;
		_this.resize(writeIndex + otherLength);

		while (readIndex < otherLength) {
			set(_this, writeIndex, get(other, readIndex));
			++writeIndex;
			++readIndex;
		}
	}
}
