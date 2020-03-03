package banker.ds.vector.extension;

class Search {
	/**
		Searches `element` in `this` vector and returns the index number.
		@param element The element to search.
		@return The found index. `-1` if not found.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function findIn<T>(
		_this: Vector<T>,
		element: T,
		startIndex: Int,
		endIndex: Int
	): Int {
		assert(startIndex >= 0 && endIndex <= _this.length);
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
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function find<T>(_this: Vector<T>, element: T): Int {
		return findIn(_this, element, 0, _this.length);
	}

	/**
		@param element Element to search.
		@return `true` if this list contains `element`.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function containsIn<T>(
		_this: Vector<T>,
		element: T,
		startIndex: Int,
		endIndex: Int
	): Bool {
		assert(startIndex >= 0 && endIndex <= _this.length);
		return findIn(_this, element, startIndex, endIndex) >= 0;
	}

	/**
		@param element Element to search.
		@return `true` if this list contains `element`.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function contains<T>(_this: Vector<T>, element: T): Bool {
		return containsIn(_this, element, 0, _this.length);
	}

	/**
		Finds the first occurrence of the element.
		@param predicate Function that returns true if the given element meets the condition.
		@return First element that matches to the given filter. Null if not found.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function findFirstIn<T>(
		_this: Vector<T>,
		predicate: T->Bool,
		startIndex: Int,
		endIndex: Int
	): Null<T> {
		assert(startIndex >= 0 && endIndex <= _this.length);
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
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function findFirst<T>(_this: Vector<T>, predicate: T->Bool): Null<T> {
		return findFirstIn(_this, predicate, 0, _this.length);
	}
}
