package banker.vector;

import banker.vector.internal.RawVector;

/**
	Read-only reference to a vector.
**/
@:forward(length, toArray)
// @formatter:off
@:using(
	banker.vector.extension.Copy,
	banker.vector.extension.Functional,
	banker.vector.extension.Scan,
	banker.vector.extension.Search
) // @formatter:on
@:allow(banker.vector)
@:notNull
abstract VectorReference<T>(RawVector<T>) from RawVector<T> {
	var data(get, never): RawVector<T>;

	extern inline function get_data()
		return this;

	@:op([]) public extern inline function get(index: UInt): T
		return this[index];
}
