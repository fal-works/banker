package banker.array;

import banker.array.ArrayExtension.*;

class ArrayFunctionalExtension {
	/**
		Runs a given function for each element.
		@param   array
		@param   callback
	**/
	public static inline function forEach<T>(array: Array<T>, callback: T->Void): Void {
		final len = array.length;
		var i = 0;
		while (i < len) {
			callback(get(array, i));
			++i;
		}
	}

	/**
		Fills the entire `array` with values created from `factory`.
		@param array
		@param predicate
		@return Null<T>
	**/
	public static inline function populate<T>(
		array: Array<T>,
		factory: Void->T
	): Array<T> {
		final len = array.length;
		var i = 0;
		while (i < len) {
			set(array, i, factory());
			++i;
		}

		return array;
	}

	/**
		Checks if the array contains one or more elements that match to the given filter.
		@param   array
		@param   predicate Function that returns true if the given element meets the condition.
		@return  True if found.
	**/
	public static inline function hasMatching<T>(
		array: Array<T>,
		predicate: T->Bool
	): Bool {
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

	/**
		Finds the first occurrence of the element.
		@param   array
		@param   predicate Function that returns true if the given element meets the condition.
		@return  First element that matches to the given filter. Null if not found.
	**/
	public static inline function findFirst<T>(
		array: Array<T>,
		predicate: T->Bool
	): Null<T> {
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
	public static inline function forFirst<T>(
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
	public static inline function filterForEach<T>(
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
		An alternative to `Lambda.map()`.
		@return New array with elements that are mapped from `array` by `callback`.
	**/
	public static inline function map<T, S>(array: Array<T>, callback: T->S): Array<S> {
		final newArray = ArrayTools.allocate(array.length);

		final len = array.length;
		var i = 0;
		while (i < len) {
			newArray[i] = callback(get(array, i));
			++i;
		}

		return newArray;
	}
}
