package banker.vector.extension.writable;

class Functional {
	/**
		@see `banker.vector.extension.Functional.forEachIndexIn()`
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
		@see `banker.vector.extension.Functional.forEachIndex()`
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
