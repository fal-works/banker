package banker.map.interfaces;

interface Sequence<K, V> {
	/**
		Runs `callback` for each key.
	**/
	function forEachKey(callback: (key: K) -> Void): Void;

	/**
		Runs `callback` for each value.
	**/
	function forEachValue(callback: (value: V) -> Void): Void;

	/**
		Runs `callback` for each key-value pair.
	**/
	function forEach(callback: (key: K, value: V) -> Void): Void;

	/**
		Runs `callback` for each key-value pair.
	**/
	function forEachIndex(
		callback: (
			index: Int,
			keys: WritableVector<K>,
			values: WritableVector<V>
		) -> Void
	): Void;

	/**
		Runs `callback` for the first found key-value pair that match `predicate`.
		@param predicate Function that returns `true` if the given entry meets condition.
		@param callback Function to apply to the found entry.
		@return `true` if found.
	**/
	function forFirst(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool;
}
