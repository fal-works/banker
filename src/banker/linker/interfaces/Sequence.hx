package banker.linker.interfaces;

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
}
