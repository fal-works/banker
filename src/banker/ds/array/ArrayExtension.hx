package banker.ds.array;

class ArrayExtension {
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function get<T>(array: Array<T>, index: Int): T {
		assert(index >= 0 && index < array.length, null, "Out of bound.");

		#if cpp
		return cpp.NativeArray.unsafeGet(array, index);
		#else
		return array[index];
		#end
	}

	#if !banker_generic_disable
	@:generic
	#end
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

	#if !banker_generic_disable
	@:generic
	#end
	public static inline function getLast<T>(array: Array<T>): T {
		#if cpp
		return cpp.NativeArray.unsafeGet(array, array.length - 1);
		#else
		return array[array.length - 1];
		#end
	}

	public static function fillIn<T>(
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

	public static function populate<T>(array: Array<T>, factory: Void->T): Array<T> {
		final len = array.length;
		var i = 0;
		while (i < len) {
			set(array, i, factory());
			++i;
		}

		return array;
	}

	/**
		Copies elements from source to destination position within a same array.
		@param   array
		@param   sourcePosition
		@param   destinationPosition
		@param   rangeLength - Number of elements to copy.
		@return  Array<T> - The given array.
	**/
	#if !banker_generic_disable
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
		Finds the first occurrence of the element.
		@param   array
		@param   predicate Function that returns true if the given element meets the condition.
		@return  First element that matches to the given filter. Null if not found.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function findFirst<T>(array: Array<T>, predicate: T->Bool): Null<T> {
		var element: Null<T> = null;

		final len = array.length;
		var i = 0;
		while (i < len) {
			element = get(array, i);
			if (predicate(element)) break;
			++i;
		}

		return element;
	}

	/**
		Runs a given function for the first occurrence of the element.
		@param   array
		@param   predicate Function that returns true if the given element meets the condition.
		@param   processCallback Function to run for the found element.
		@return  True if found.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function forFirst<T>(
		array: Array<T>,
		predicate: T->Bool,
		processCallback: T->Void
	): Bool {
		var element: T;
		var found = false;

		final len = array.length;
		var i = 0;
		while (i < len) {
			element = get(array, i);
			if (predicate(element)) {
				processCallback(element);
				found = true;
				break;
			}

			++i;
		}

		return found;
	}

	/**
		Runs a given function for each occurrence of the matching element.
		@param   array
		@param   predicate Function that returns true if the given element meets the condition.
		@param   processCallback Function to run for the found element.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function filterForEach<T>(
		array: Array<T>,
		predicate: T->Bool,
		processCallback: T->Void
	): Void {
		var element: T;

		final len = array.length;
		var i = 0;
		while (i < len) {
			element = get(array, i);
			if (predicate(element)) processCallback(element);
			++i;
		}
	}

	/**
		Runs a given function for each element.
		@param   array
		@param   callback
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEach<T>(array: Array<T>, callback: T->Void): Void {
		final len = array.length;
		var i = 0;
		while (i < len) {
			callback(get(array, i));
			++i;
		}
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
	public static function contains<T>(array: Array<T>, value: T): Bool {
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
		Checks if the array contains one or more elements that match to the given filter.
		@param   array
		@param   predicate Function that returns true if the given element meets the condition.
		@return  True if found.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function containsMatching<T>(array: Array<T>, predicate: T->Bool): Bool {
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
