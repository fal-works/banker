package banker.vector.extension.writable;

class Fill {
	/**
		Fills the vector with `value` beginning at `startIndex` until (but not including) `endIndex`.
		@return Filled `this`.
	**/
	public static inline function fillIn<T>(
		_this: WritableVector<T>,
		value: T,
		startIndex: Int,
		endIndex: Int
	): WritableVector<T> {
		assert(startIndex >= 0 && endIndex <= _this.length);

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
		for (i in 0..._this.length) _this.set(i, value);

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
		assert(factory != null);

		for (i in 0..._this.length) _this.set(i, factory());

		return _this;
	}
}
