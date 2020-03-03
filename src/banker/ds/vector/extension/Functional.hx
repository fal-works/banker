package banker.ds.vector.extension;

class Functional {
	/**
		Runs `callback` for each element in `this` vector
		from `startIndex` until (but not including) `endIndex`.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEachIn<T>(
		_this: Vector<T>,
		callback: T->Void,
		startIndex: Int,
		endIndex: Int
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
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEach<T>(_this: Vector<T>, callback: T->Void): Void {
		forEachIn(_this, callback, 0, _this.length);
	}

	/**
		@see `Functional.filterIn()`
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function filterIn<T>(
		_this: Vector<T>,
		predicate: T->Bool,
		startIndex: Int,
		endIndex: Int
	): Vector<T> {
		return Functional.filterInWritable(_this, predicate, startIndex, endIndex);
	}

	/**
		@see `Functional.filter()`
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function filter<T>(
		_this: Vector<T>,
		predicate: T->Bool
	): Vector<T> {
		return Functional.filterWritable(_this, predicate);
	}

	/**
		Creates a new vector by filtering elements of `this` with `predicate`
		whithin the range from `startIndex` until (but not including) `endIndex`.
		@param predicate Function that returns true if the element should be remain.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function filterInWritable<T>(
		_this: Vector<T>,
		predicate: T->Bool,
		startIndex: Int,
		endIndex: Int
	): WritableVector<T> {
		final buffer = new Array<T>();
		var i = startIndex;
		while (i < endIndex) {
			final item = _this[i];
			if (predicate(item)) buffer.push(item);
			++i;
		}

		return WritableVector.fromArrayCopy(buffer);
	}

	/**
		Creates a new vector by filtering elements of `this` with `predicate`.
		@param predicate Function that returns true if the element should be remain.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function filterWritable<T>(
		_this: Vector<T>,
		predicate: T->Bool
	): WritableVector<T> {
		return filterInWritable(_this, predicate, 0, _this.length);
	}
}

class WritableFunctional {
	/**
		Runs `callback` for each element in `this` vector
		from `startIndex` until (but not including) `endIndex`.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEachIndexIn<T>(
		_this: WritableVector<T>,
		callback: (
			element: T,
			index: Int,
			vector: WritableVector<T>
		) -> Void,
		startIndex: Int,
		endIndex: Int
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
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEachIndex<T>(
		_this: WritableVector<T>,
		callback: (
			element: T,
			index: Int,
			vector: WritableVector<T>
		) -> Void
	): Void {
		forEachIndexIn(_this, callback, 0, _this.length);
	}
}

class ReadOnlyFunctional {
	/**
		@see `Functional.forEachIndexIn()`
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEachIndexIn<T>(
		_this: Vector<T>,
		callback: (
			element: T,
			index: Int,
			vector: Vector<T>
		) -> Void,
		startIndex: Int,
		endIndex: Int
	): Void {
		var i = startIndex;
		while (i < endIndex) {
			callback(_this[i], i, _this);
			++i;
		}
	}

	/**
		@see `Functional.forEachIndex()`
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEachIndex<T>(
		_this: Vector<T>,
		callback: (
			element: T,
			index: Int,
			vector: Vector<T>
		) -> Void
	): Void {
		forEachIndexIn(_this, callback, 0, _this.length);
	}

	// forward: forEachIn, forEach
}
