package banker.vector.extension.writable;

class Fill {
	/**
		Fills the vector with `value` beginning at `startIndex` until (but not including) `endIndex`.
		@return Filled `this`.
	**/
	public static inline function fillIn<T>(
		_this: WritableVector<T>,
		value: T,
		startIndex: UInt,
		endIndex: UInt
	): WritableVector<T> {
		#if !macro
		assert(endIndex <= _this.length);
		#end

		for (i in startIndex...endIndex) _this.set(i, value);

		return _this;
	}

	/**
		Fills the entire vector with `value`.
		@return Filled `this`.
	**/
	public static inline function fill<T>(
		_this: WritableVector<T>,
		value: T
	): WritableVector<T> {
		for (i in UInt.zero..._this.length) _this.set(i, value);

		return _this;
	}

	/**
		Fills the entire vector with instances created from `factory`.
		@return Filled `this`.
	**/
	public static inline function populate<T>(
		_this: WritableVector<T>,
		factory: Void->T
	): WritableVector<T> {
		#if !macro
		assert(factory != null);
		#end

		for (i in UInt.zero..._this.length) _this.set(i, factory());

		return _this;
	}
}
