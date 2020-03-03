package banker.ds.vector.extension;

@:access(banker.ds.vector.VectorReference, banker.ds.vector.WritableVector)
class Functional {
	/**
		Runs `callback` for each element in `this` vector
		from `startIndex` until (but not including) `endIndex`.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEachIn<T>(
		_this: VectorReference<T>,
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
	public static inline function forEach<T>(_this: VectorReference<T>, callback: T->Void): Void {
		forEachIn(_this, callback, 0, _this.length);
	}

	/**
		Creates a new vector by filtering elements of `this` with `predicate`
		whithin the range from `startIndex` until (but not including) `endIndex`.
		@param predicate Function that returns true if the element should be remain.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function filterIn<T>(
		_this: VectorReference<T>,
		predicate: T->Bool,
		startIndex: Int,
		endIndex: Int
	): VectorReference<T> {
		final buffer = new Array<T>();
		var i = startIndex;
		while (i < endIndex) {
			final item = _this[i];
			if (predicate(item)) buffer.push(item);
			++i;
		}

		return VectorReference.fromArrayCopy(buffer);
	}

	/**
		Creates a new vector by filtering elements of `this` with `predicate`.
		@param predicate Function that returns true if the element should be remain.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function filter<T>(_this: VectorReference<T>, predicate: T->Bool): VectorReference<T> {
		return filterIn(_this, predicate, 0, _this.length);
	}

	/**
		@see `Functional.filterIn()`
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function filterInWritable<T>(
		_this: VectorReference<T>,
		predicate: T->Bool,
		startIndex: Int,
		endIndex: Int
	): WritableVector<T> {
		return filterIn(_this, predicate, startIndex, endIndex).writable();
	}

	/**
		@see `Functional.filter()`
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function filterWritable<T>(
		_this: VectorReference<T>,
		predicate: T->Bool
	): WritableVector<T> {
		return filter(_this, predicate).writable();
	}

	/**
		@see `mapIn()`
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function mapInWritable<T, S>(
		_this: VectorReference<T>,
		callback: T->S,
		startIndex: Int,
		endIndex: Int
	): WritableVector<S> {
		final newVector = new WritableVector<S>(endIndex - startIndex);
		var i = startIndex;
		var k = 0;
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
	#if !banker_generic_disable
	@:generic
	#end
	public static function mapWritable<T, S>(
		_this: VectorReference<T>,
		callback: T->S
	): WritableVector<S> {
		return WritableVector.fromData(_this.data.map(callback));
	}

	/**
		Creates a new vector by mapping elements of `this` using `callback`
		whithin the range from `startIndex` until (but not including) `endIndex`.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function mapIn<T, S>(
		_this: VectorReference<T>,
		callback: T->S,
		startIndex: Int,
		endIndex: Int
	): VectorReference<S> {
		return mapInWritable(_this, callback, startIndex, endIndex).ref;
	}

	/**
		Creates a new vector by mapping elements of `this` using `callback`.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function map<T, S>(
		_this: VectorReference<T>,
		callback: T->S
	): VectorReference<S> {
		return mapWritable(_this, callback).ref;
	}

	/**
		Runs `callback` for each element in `this` vector
		from `startIndex` until (but not including) `endIndex`.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function forEachIndexIn<T>(
		_this: VectorReference<T>,
		callback: (
			element: T,
			index: Int,
			vector: VectorReference<T>
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
		_this: VectorReference<T>,
		callback: (
			element: T,
			index: Int,
			vector: VectorReference<T>
		) -> Void
	): Void {
		forEachIndexIn(_this, callback, 0, _this.length);
	}
}

class WritableFunctional {
	/**
		@see `Functional.forEachIndexIn()`
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
		@see `Functional.forEachIndex()`
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
