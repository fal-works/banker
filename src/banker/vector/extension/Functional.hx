package banker.vector.extension;

class Functional {
	/**
		Runs `callback` for each element in `this` vector
		from `startIndex` until (but not including) `endIndex`.
	**/
	public static inline function forEachIn<T>(
		_this: VectorReference<T>,
		callback: T->Void,
		startIndex: UInt,
		endIndex: UInt
	): Void {
		var i = startIndex;
		while (i < endIndex) {
			callback(_this[i]);
			++i;
		}
	}

	/**
		Runs `callback` for each element in `this` vector.
	**/
	public static inline function forEach<T>(
		_this: VectorReference<T>,
		callback: T->Void
	): Void {
		forEachIn(_this, callback, UInt.zero, _this.length);
	}

	/**
		Creates a new vector by filtering elements of `this` with `predicate`
		whithin the range from `startIndex` until (but not including) `endIndex`.
		@param predicate Function that returns true if the element should be remain.
	**/
	public static inline function filterIn<T>(
		_this: VectorReference<T>,
		predicate: T->Bool,
		startIndex: UInt,
		endIndex: UInt
	): Vector<T> {
		final buffer = new Array<T>();
		var i = startIndex;
		while (i < endIndex) {
			final item = _this[i];
			if (predicate(item)) buffer.push(item);
			++i;
		}

		return Vector.fromArrayCopy(buffer);
	}

	/**
		Creates a new vector by filtering elements of `this` with `predicate`.
		@param predicate Function that returns true if the element should be remain.
	**/
	public static inline function filter<T>(
		_this: VectorReference<T>,
		predicate: T->Bool
	): Vector<T> {
		return filterIn(_this, predicate, UInt.zero, _this.length);
	}

	/**
		@see `Functional.filterIn()`
	**/
	public static inline function filterInWritable<T>(
		_this: VectorReference<T>,
		predicate: T->Bool,
		startIndex: UInt,
		endIndex: UInt
	): WritableVector<T> {
		return filterIn(_this, predicate, startIndex, endIndex).writable();
	}

	/**
		@see `Functional.filter()`
	**/
	public static inline function filterWritable<T>(
		_this: VectorReference<T>,
		predicate: T->Bool
	): WritableVector<T> {
		return filter(_this, predicate).writable();
	}

	/**
		@see `mapIn()`
	**/
	public static inline function mapInWritable<T, S>(
		_this: VectorReference<T>,
		callback: T->S,
		startIndex: UInt,
		endIndex: UInt
	): WritableVector<S> {
		final newVector = new WritableVector<S>(endIndex - startIndex);
		var i = startIndex;
		var k = UInt.zero;
		while (i < endIndex) {
			newVector[k] = callback(_this[i]);
			++i;
			++k;
		}

		return newVector;
	}

	/**
		@see `map()`
	**/
	public static inline function mapWritable<T, S>(
		_this: VectorReference<T>,
		callback: T->S
	): WritableVector<S> {
		return _this.data.map(callback);
	}

	/**
		Creates a new vector by mapping elements of `this` using `callback`
		whithin the range from `startIndex` until (but not including) `endIndex`.
	**/
	public static inline function mapIn<T, S>(
		_this: VectorReference<T>,
		callback: T->S,
		startIndex: UInt,
		endIndex: UInt
	): Vector<S> {
		return mapInWritable(_this, callback, startIndex, endIndex).nonWritable();
	}

	/**
		Creates a new vector by mapping elements of `this` using `callback`.
	**/
	public static inline function map<T, S>(
		_this: VectorReference<T>,
		callback: T->S
	): Vector<S> {
		return mapWritable(_this, callback).nonWritable();
	}

	/**
		Runs `callback` for each element in `this` vector
		from `startIndex` until (but not including) `endIndex`.
	**/
	public static inline function forEachIndexIn<T>(
		_this: VectorReference<T>,
		callback: (
			element: T,
			index: UInt,
			vector: VectorReference<T>
		) -> Void,
		startIndex: UInt,
		endIndex: UInt
	): Void {
		var i = startIndex;
		while (i < endIndex) {
			callback(_this[i], i, _this);
			++i;
		}
	}

	/**
		Runs `callback` for each element in `this` vector.
	**/
	public static inline function forEachIndex<T>(
		_this: VectorReference<T>,
		callback: (
			element: T,
			index: UInt,
			vector: VectorReference<T>
		) -> Void
	): Void {
		forEachIndexIn(_this, callback, UInt.zero, _this.length);
	}
}
