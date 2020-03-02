package banker.type_extension;

@:nullSafety(Strict)
class NullableExtension {
	/**
		@return `true` if `_this` is null.
	**/
	public static inline function isNull<T>(_this: Null<T>): Bool {
		return _this == null;
	}

	/**
		@return `true` if `_this` is not null.
	**/
	public static inline function exists<T>(_this: Null<T>): Bool {
		return !isNull(_this);
	}

	/**
		@return `_this` if it is not null. Otherwise `defaultValue`.
	**/
	public static inline function or<T>(_this: Null<T>, defaultValue: T): T {
		return exists(_this) ? _this : defaultValue;
	}

	/**
		@return `_this` if it is not null. Otherwise the result of `getDefaultValue()`.
	**/
	public static inline function orElse<T>(_this: Null<T>, getDefaultValue: () -> T): T {
		return exists(_this) ? _this : getDefaultValue();
	}

	/**
		Runs `callback` only if `_this` is not null.
		@param callback A function that takes `_this` as argument.
	**/
	public static inline function may<T>(_this: Null<T>, callback: T->Void): Void {
		if (exists(_this))
			callback(_this);
	}

	/**
		Maps `_this` to another value only if it is not null.
		@return The result of `callback` if `_this` is not null. Otherwise `null`.
	**/
	public static inline function map<T, U>(_this: Null<T>, callback: T->U): Null<U> {
		return exists(_this) ? callback(_this) : null;
	}
}
