package banker.array;

import banker.array.ArrayFunctionalExtension.hasEqual;
import banker.vector.WritableVector;

class ArrayExtension {
	/**
		@return The element at `index`.
	**/
	public static inline function get<T>(_this: Array<T>, index: Int): T {
		#if !macro
		assert(index >= 0 && index < _this.length, null, "Out of bound.");
		#end

		#if cpp
		return cpp.NativeArray.unsafeGet(_this, index);
		#else
		return _this[index];
		#end
	}

	/**
		Sets `value` at `index`.
	**/
	public static inline function set<T>(
		_this: Array<T>,
		index: Int,
		value: T
	): Void {
		#if !macro
		assert(index >= 0 && index < _this.length, null, "Out of bound.");
		#end

		#if cpp
		cpp.NativeArray.unsafeSet(_this, index, value);
		#else
		_this[index] = value;
		#end
	}

	/**
		@return The last element of the array.
	**/
	public static inline function getLast<T>(_this: Array<T>): T {
		#if cpp
		return cpp.NativeArray.unsafeGet(_this, _this.length - 1);
		#else
		return _this[_this.length - 1];
		#end
	}

	/**
		Fills the array with `value` from `startIndex` to (but not including) `endIndex`.
		@return The filled array.
	**/
	public static inline function fillIn<T>(
		_this: Array<T>,
		value: T,
		startIndex: Int,
		endIndex: Int
	): Array<T> {
		#if !macro
		assert(startIndex >= 0 && endIndex < _this.length);
		#end

		var i = startIndex;
		while (i < endIndex) {
			set(_this, i, value);
			++i;
		}

		return _this;
	}

	/**
		Fills the array with `value`.
		@return The filled array.
	**/
	public static inline function fill<T>(_this: Array<T>, value: T): Array<T> {
		return fillIn(_this, value, 0, _this.length);
	}

	/**
		Copies elements from source to destination position within a same array.
	**/
	public static inline function blitInternal<T>(
		_this: Array<T>,
		sourcePosition: Int,
		destinationPosition: Int,
		rangeLength: Int
	): Void {
		#if !macro
		assert(sourcePosition + rangeLength <= _this.length);
		assert(destinationPosition + rangeLength <= _this.length);
		#end

		#if cpp
		cpp.NativeArray.blit(
			_this,
			destinationPosition,
			_this,
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
				_this[k] = _this[i];
			}
		} else if (sourcePosition > destinationPosition) {
			var i = sourcePosition;
			var k = destinationPosition;
			final endI = sourcePosition + rangeLength;

			while (i < endI) {
				_this[k] = _this[i];
				++i;
				++k;
			}
		}
		#end
	}

	/**
		@return `true` if the array contains an element that is `element == value`.
	**/
	public static inline function has<T>(_this: Array<T>, value: T): Bool
		return _this.indexOf(value, 0) >= 0;

	/**
		@return `true` if the array is not null and contains an element that is `element == value`.
	**/
	public static inline function existsAndHas<T>(_this: Null<Array<T>>, value: T): Bool
		return _this != null && has(_this, value);

	/**
		@return The first found element that is `element == value`.
	**/
	public static inline function find<T>(
		_this: Array<T>,
		value: T,
		defaultValue: T
	): T {
		final index = _this.indexOf(value, 0);
		return if (index >= 0) get(_this, index) else defaultValue;
	}

	/**
		@return The first found element that is `element == value`.
		`defaultValue` if this array is `null` or the element is not found.
	**/
	public static inline function findIfNotNull<T>(
		_this: Null<Array<T>>,
		value: T,
		defaultValue: T
	): T {
		return if (_this != null) find(_this, value, defaultValue) else defaultValue;
	}

	/**
		Swaps elements at `indexA` and `indexB`.
	**/
	public static inline function swap<T>(
		_this: Array<T>,
		indexA: Int,
		indexB: Int
	): Void {
		#if !macro
		assert(indexA >= 0 && indexA < _this.length);
		assert(indexB >= 0 && indexB < _this.length);
		#end

		var tmp = get(_this, indexA);
		set(_this, indexA, get(_this, indexB));
		set(_this, indexB, tmp);
	}

	/**
		Compares two arrays with `==` operator.
		@return `true` if all elements are equal (including the order).
	**/
	public static inline function equals<T>(_this: Array<T>, other: Array<T>): Bool {
		final len = _this.length;

		return if (other.length != len) false; else {
			var foundDifference = false;

			for (i in 0...len) {
				if (get(_this, i) == get(other, i)) continue;

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
		_this: Array<T>,
		other: Array<T>,
		comparator: (a: T, b: T) -> Bool
	): Bool {
		final len = _this.length;

		return if (other.length != len) false; else {
			var foundDifference = false;

			for (i in 0...len) {
				if (comparator(get(_this, i), get(other, i))) continue;

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

	/**
		Removes an element at `index.
		@return Removed element.
	**/
	public static inline function removeAt<T>(_this: Array<T>, index: Int): T {
		final arrayLength = _this.length;
		final rangeLength = arrayLength - index - 1;
		final removed = get(_this, index);

		blitInternal(_this, index + 1, index, rangeLength);
		_this.resize(arrayLength - 1);

		return removed;
	}

	/**
		Concatenates all arrays.
		@return New array.
	**/
	public static inline function flatten<T>(arrays: Array<Array<T>>): Array<T> {
		final arrayCount = arrays.length;
		var elementCount = 0;
		for (i in 0...arrayCount) elementCount += arrays[i].length;

		final newArray = ArrayTools.allocate(elementCount);
		var i = 0;

		for (k in 0...arrayCount) {
			final array = arrays[k];

			for (m in 0...array.length) {
				newArray[i] = array[m];
				++i;
			}
		}

		return newArray;
	}

	/**
		Pushes `value` to `this` only if `this` does not have any element equal to `value`.
		@return `true` if pushed.
	**/
	public static inline function pushIfAbsent<T>(_this: Array<T>, value: T): Bool {
		if (has(_this, value)) return false;

		_this.push(value);
		return true;
	}

	/**
		Pushes `value` to `this` only if `this` does not have any element equal to `value`.
		@param equalityPredicate Function that returns `true` if two given elements
		  should be considered as equal.
		@return `true` if pushed.
	**/
	public static inline function pushIfNotFound<T>(
		_this: Array<T>,
		value: T,
		equalityPredicate: (a: T, b: T) -> Bool
	): Bool {
		if (hasEqual(_this, value, equalityPredicate)) return false;

		_this.push(value);
		return true;
	}


	/**
		Copies `this` and also deduplicates values.
		O(n^2) complexity (which is not very good).
		@return New array with deduplicated values from `this`.
	**/
	public static inline function copyDeduplicated<T>(
		_this: Array<T>
	): Array<T> {
		final length = _this.length;

		return if (length == 0) _this.copy() else {
			final newVector = new WritableVector(length);

			newVector[0] = get(_this, 0);
			var writeIndex = 1;

			for (readIndex in 1...length) {
				final value = get(_this, readIndex);
				if (newVector.ref.hasIn(value, 0, writeIndex)) continue;

				newVector[writeIndex] = value;
				++writeIndex;
			}

			newVector.ref.sliceToArray(0, writeIndex);
		}
	}
}
