package banker.vector.extension;

class Search {
	/**
		Searches `element` in `this` vector and returns the index number.
		@param element The element to search.
		@return The found index. `-1` if not found.
	**/
	public static inline function findIndexIn<T>(
		_this: VectorReference<T>,
		element: T,
		startIndex: Int,
		endIndex: Int
	): Int {
		#if !macro
		assert(startIndex >= 0 && endIndex <= _this.length);
		#end
		var found = -1;
		var i = startIndex;
		while (i < endIndex) {
			if (_this[i] == element) {
				found = i;
				break;
			}
			++i;
		}

		return found;
	}

	/**
		Searches `element` in `this` vector and returns the index number.
		@param element The element to search.
		@param fromIndex The index to start the search.
		@return The found index. `-1` if not found.
	**/
	public static inline function findIndex<T>(
		_this: VectorReference<T>,
		element: T
	): Int {
		return findIndexIn(_this, element, 0, _this.length);
	}

	/**
		@param element Element to search.
		@return `true` if this list contains `element`.
	**/
	public static inline function hasIn<T>(
		_this: VectorReference<T>,
		element: T,
		startIndex: Int,
		endIndex: Int
	): Bool {
		#if !macro
		assert(startIndex >= 0 && endIndex <= _this.length);
		#end
		var found = false;
		var i = startIndex;
		while (i < endIndex) {
			if (_this[i] == element) {
				found = true;
				break;
			}
			++i;
		}

		return found;
	}

	/**
		@param element Element to search.
		@return `true` if this list contains `element`.
	**/
	public static inline function has<T>(_this: VectorReference<T>, element: T): Bool {
		return hasIn(_this, element, 0, _this.length);
	}

	/**
		@param element Element to search.
		@param equalityPredicate Function that returns `true` if two given elements
		  should be considered as equal.
		@return `true` if `this` contains `element`.
	**/
	public static inline function hasEqualIn<T>(
		_this: VectorReference<T>,
		element: T,
		equalityPredicate: T->T->Bool,
		startIndex: Int,
		endIndex: Int
	): Bool {
		#if !macro
		assert(startIndex >= 0 && endIndex <= _this.length);
		#end
		var found = false;
		var i = startIndex;
		while (i < endIndex) {
			if (equalityPredicate(_this[i], element)) {
				found = true;
				break;
			}
			++i;
		}

		return found;
	}

	/**
		@param element Element to search.
		@param equalityPredicate Function that returns `true` if two given elements
		  should be considered as equal.
		@return `true` if `this` contains `element`.
	**/
	public static inline function hasEqual<T>(
		_this: VectorReference<T>,
		element: T,
		equalityPredicate: T->T->Bool
	): Bool {
		return hasEqualIn(_this, element, equalityPredicate, 0, _this.length);
	}

	/**
		Finds the first occurrence of the element.
		@param predicate Function that returns true if the given element meets the condition.
		@return First element that matches to the given filter. Null if not found.
	**/
	public static inline function findFirstIn<T>(
		_this: VectorReference<T>,
		predicate: T->Bool,
		startIndex: Int,
		endIndex: Int
	): Null<T> {
		#if !macro
		assert(startIndex >= 0 && endIndex <= _this.length);
		#end
		var element: T;
		var found: Null<T> = null;

		var i = startIndex;
		while (i < endIndex) {
			element = _this[i];
			if (predicate(element)) {
				found = element;
				break;
			}
			++i;
		}

		return found;
	}

	/**
		Finds the first occurrence of the element.
		@param predicate Function that returns true if the given element meets the condition.
		@return First element that matches to the given filter. Null if not found.
	**/
	public static inline function findFirst<T>(
		_this: VectorReference<T>,
		predicate: T->Bool
	): Null<T> { @:nullSafety(Off) // XXX: Don't know why this is necessary
		return findFirstIn(_this, predicate, 0, _this.length);
	}
}
