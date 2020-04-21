package banker.vector.extension.writable;

class Functional {
	/**
		@see `banker.vector.extension.Functional.forEachIndexIn()`
	**/
	public static inline function forEachIndexIn<T>(
		_this: WritableVector<T>,
		callback: (
			element: T,
			index: UInt,
			vector: WritableVector<T>
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
		@see `banker.vector.extension.Functional.forEachIndex()`
	**/
	public static inline function forEachIndex<T>(
		_this: WritableVector<T>,
		callback: (
			element: T,
			index: UInt,
			vector: WritableVector<T>
		) -> Void
	): Void {
		forEachIndexIn(_this, callback, UInt.zero, _this.length);
	}
}
