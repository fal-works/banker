package banker.ds;

class ArrayExtension {
	public static function nullify<T:{}>(array:Array<T>):Void {
		#if safe
		if (array == null) throw "ArrayUtility.nullify(): Passed null.";
		#end

		#if cpp
		cpp.NativeArray.zero(array, 0, array.length);
		#else
		for (i in 0...array.length) set(array, i, cast null);
		#end
	}

	@:generic
	public static inline function get<T>(array:Array<T>, index:Int):T {
		#if safe
		if (array == null) throw "ArrayUtility.get(): Passed null.";
		if (index < 0 || index >= array.length) throw "ArrayUtility.get(): index " + index + " is out of bound.";
		#end

		return
		#if cpp
		cpp.NativeArray.unsafeGet(array, index);
		#else
		array[index];
		#end
	}

	@:generic
	public static inline function set<T>(array:Array<T>, index:Int, obj:T):Void {
		#if safe
		if (array == null) throw "ArrayUtility.set(): Passed null.";
		if (index < 0 || index >= array.length) throw "ArrayUtility.set(): index " + index + " is out of bound.";
		#end

		#if cpp
		cpp.NativeArray.unsafeSet(array, index, obj);
		#else
		array[index] = obj;
		#end
	}

	@:generic
	public static inline function getLast<T>(array:Array<T>):T {
		#if safe
		if (array == null) throw "ArrayUtility.getLast(): Passed null.";
		#end

		return
		#if cpp
		cpp.NativeArray.unsafeGet(array, array.length - 1);
		#else
		array[array.length - 1];
		#end
	}

	public static inline function fill<T>(array:Array<T>, value:T):Array<T> {
		return fillRange(array, value, 0, array.length);
	}

	public static inline function fillRange<T>(array:Array<T>, value:T, startIndex:Int, endIndex:Int):Array<T> {
		#if safe
		if (array == null)
			throw "ArrayUtility.fillRange(): Passed null.";
		if (startIndex < 0)
			throw "ArrayUtility.fillRange(): startIndex " + startIndex + " is invalid.";
		if (startIndex >= endIndex)
			throw "ArrayUtility.fillRange(): startIndex " + startIndex + " is greater than endIndex " + endIndex + ".";
		if (endIndex > array.length)
			throw "ArrayUtility.fillRange(): endIndex " + endIndex + " is greater than the array length " + array.length + ".";
		#end

		var i = startIndex;
		while (i < endIndex) {
			set(array, i, value);
			i++;
		}

		return array;
	}

	public static function populate<T>(array:Array<T>, factory:Void->T):Array<T> {
		#if safe
		if (array == null || factory == null) throw "ArrayUtility.populate(): Passed null.";
		#end

		/* fin */ var len = array.length;
		var i = 0;
		while (i < len) {
			set(array, i, factory());
			i++;
		}

		return array;
	}

	/**
	 * Copies elements from source to destination position within a same array.
	 * @param   array
	 * @param   sourcePosition
	 * @param   destinationPosition
	 * @param   rangeLength - Number of elements to copy.
	 * @return  Array<T> - The given array.
	 */
	@:generic
	#if (cs || java || neko || cpp)
	inline
	#end
	public static function blitInternal<T>(
		array:Array<T>,
		sourcePosition:Int,
		destinationPosition:Int,
		rangeLength:Int
	):Array<T> {
		#if safe
		if (array == null) throw "ArrayUtility.blitInternal(): Passed null.";
		if (
			rangeLength <= 0 ||
			sourcePosition + rangeLength > array.length ||
			destinationPosition + rangeLength > array.length
		) throw "ArrayUtility.blitInternal(): rangeLength " + rangeLength + " is invalid.";
		#end

		#if cpp
		cpp.NativeArray.blit(array, destinationPosition, array, sourcePosition, rangeLength);
		#elseif java
		java.lang.System.arraycopy(array, sourcePosition, array, destinationPosition, rangeLength);
		#else
		if (sourcePosition < destinationPosition) {
			var i = sourcePosition + rangeLength;
			var j = destinationPosition + rangeLength;

			for (k in 0...rangeLength) {
				i--;
				j--;
				array[j] = array[i];
			}
		} else if (sourcePosition > destinationPosition) {
			var i = sourcePosition;
			var j = destinationPosition;

			for (k in 0...rangeLength) {
				array[j] = array[i];
				i++;
				j++;
			}
		}
		#end

		return array;
	}

	/**
	 * Finds the first occurrence of the element.
	 * @param   array
	 * @param   filterCallback Function that returns true if the given element meets the condition.
	 * @return  First element that matches to the given filter. Null if not found.
	 */
	@:generic
	public static function findFirstOccurrence<T>(array:Array<T>, filterCallback:T->Bool):Null<T> {
		var element:T;

		/* fin */ var len = array.length;
		var i = 0;
		while (i < len) {
			element = get(array, i);
			if (filterCallback(element)) return element;

			i++;
		}

		return null;
	}

	/**
	 * Runs a given function for the first occurrence of the element.
	 * @param   array
	 * @param   filterCallback Function that returns true if the given element meets the condition.
	 * @param   processCallback Function to run for the found element.
	 * @return  True if found.
	 */
	@:generic
	public static function forFirstOccurrence<T>(array:Array<T>, filterCallback:T->Bool, processCallback:T->Void):Bool {
		var element:T;

		/* fin */ var len = array.length;
		var i = 0;
		while (i < len) {
			element = get(array, i);
			if (filterCallback(element)) {
				processCallback(element);
				return true;
			}

			i++;
		}

		return false;
	}

	/**
	 * Runs a given function for each occurrence of the matching element.
	 * @param   array
	 * @param   filterCallback Function that returns true if the given element meets the condition.
	 * @param   processCallback Function to run for the found element.
	 */
	@:generic
	public static inline function forEachOccurrence<T>(array:Array<T>, filterCallback:T->Bool, processCallback:T->Void):Void {
		/* fin */ var len = array.length;
		var i = 0;
		while (i < len) {
			if (filterCallback(get(array, i))) {
				processCallback(get(array, i));
			}
			i++;
		}
	}

	/**
	 * Runs a given function for each element.
	 * @param   array
	 * @param   callback
	 */
	@:generic
	public static function forEach<T>(array:Array<T>, callback:T->Void):Void {
		/* fin */ var len = array.length;
		var i = 0;
		while (i < len) {
			callback(get(array, i));
			i++;
		}
	}

	/**
	 * Checks if the array contains the element.
	 * @param   array
	 * @param   value
	 * @return  True if the element is contained.
	 */
	@:generic
	public static function contains<T>(array:Array<T>, value:T):Bool {
		/* fin */ var len = array.length;
		var i = 0;
		while (i < len) {
			if (value == get(array, i)) return true;
			i++;
		}

		return false;
	}

	/**
	 * Checks if the array contains one or more elements that match to the given filter.
	 * @param   array
	 * @param   filterCallback Function that returns true if the given element meets the condition.
	 * @return  True if found.
	 */
	@:generic
	public static function containsMatching<T>(array:Array<T>, filterCallback:T->Bool):Bool {
		/* fin */ var len = array.length;
		var i = 0;
		while (i < len) {
			if (filterCallback(get(array, i))) return true;
			i++;
		}

		return false;
	}

	@:generic
	public static inline function swap<T>(array:Array<T>, indexA:Int, indexB:Int):Void {
		#if safe
		if (array == null)
			throw "ArrayUtility::swap  Passed null.";
		if (indexA < 0 || indexA >= array.length || indexB < 0 || indexB >= array.length)
			throw "ArrayUtility::swap  Invalid index.";
		#end

		var tmp = get(array, indexA);
		set(array, indexA, get(array, indexB));
		set(array, indexB, tmp);
	}
}
