package banker.array;

class NullableArrayExtension {
	/**
		@return Shallow copy of `this`, or `null` if `this` is `null`.
	**/
	public static inline function copyNullable<T>(_this: Null<Array<T>>): Null<Array<T>>
		return if (_this != null) _this.copy() else null;
}
