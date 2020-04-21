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
		startIndex: UInt,
		endIndex: UInt
	): MaybeUInt {
		#if !macro
		assert(endIndex <= _this.length);
		#end
		var found = MaybeUInt.none;
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
		@return The found index. `-1` if not found.
	**/
	public static inline function findIndex<T>(
		_this: VectorReference<T>,
		element: T
	): MaybeUInt {
		return findIndexIn(_this, element, UInt.zero, _this.length);
	}

	/**
		Finds index of the first occurrence of the element that matches `predicate`.
		@param predicate Function that returns true if the given element meets the condition.
		@return The found index. `-1` if not found.
	**/
	public static inline function findFirstIndexIn<T>(
		_this: VectorReference<T>,
		predicate: T->Bool,
		startIndex: UInt,
		endIndex: UInt
	): MaybeUInt {
		#if !macro
		assert(endIndex <= _this.length);
		#end
		var found = MaybeUInt.none;
		var i = startIndex;
		while (i < endIndex) {
			if (predicate(_this[i])) {
				found = i;
				break;
			}
			++i;
		}

		return found;
	}

	/**
		Finds index of the first occurrence of the element that matches `predicate`.
		@param predicate Function that returns true if the given element meets the condition.
		@return The found index. `-1` if not found.
	**/
	public static inline function findFirstIndex<T>(
		_this: VectorReference<T>,
		predicate: T->Bool
	): MaybeUInt {
		return findFirstIndexIn(_this, predicate, UInt.zero, _this.length);
	}

	/**
		@param element Element to search.
		@return `true` if this list contains `element`.
	**/
	public static inline function hasIn<T>(
		_this: VectorReference<T>,
		element: T,
		startIndex: UInt,
		endIndex: UInt
	): Bool {
		#if !macro
		assert(endIndex <= _this.length);
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
		return hasIn(_this, element, UInt.zero, _this.length);
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
		startIndex: UInt,
		endIndex: UInt
	): Bool {
		#if !macro
		assert(endIndex <= _this.length);
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
		return hasEqualIn(_this, element, equalityPredicate, UInt.zero, _this.length);
	}

	/**
		Finds the first occurrence of the element.
		@param predicate Function that returns true if the given element meets the condition.
		@return First element that matches to the given filter. `defaultValue` if not found.
	**/
	public static inline function findFirstIn<T>(
		_this: VectorReference<T>,
		predicate: T->Bool,
		defaultValue: T,
		startIndex: UInt,
		endIndex: UInt
	): T {
		#if !macro
		assert(endIndex <= _this.length);
		#end
		var element: T;
		var found: T = defaultValue;

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
		@return First element that matches to the given filter. `defaultValue` if not found.
	**/
	public static inline function findFirst<T>(
		_this: VectorReference<T>,
		predicate: T->Bool,
		defaultValue: T
	): T {
		return findFirstIn(_this, predicate, defaultValue, UInt.zero, _this.length);
	}
}
