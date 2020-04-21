package banker.types;

import banker.vector.WritableVector;

/**
	Reference object that enables you to pass primitive values with write access.

	Can be created from a value or converted to the value implicitly, but
	changing the value has to be done explicitly with `set()`.
	The internal representation is a vector with 1 element.
**/
@:notNull
abstract Reference<T>(WritableVector<T>) {
	@:from public static inline function fromValue<T>(value: T): Reference<T> {
		final vector = new WritableVector(UInt.one);
		vector[UInt.zero] = value;
		return new Reference(vector);
	}

	@:to public inline function get(): T
		return this[UInt.zero];

	public inline function set(value: T): T
		return this[UInt.zero] = value;

	inline function new(vector: WritableVector<T>)
		this = vector;
}
