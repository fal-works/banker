package banker.linker.interfaces;

interface Remove<K, V> {
	/**
		Finds the first key-value pair that matches `key` and removes it.
		O(n) complexity.
		@return True if found and removed.
	**/
	function remove(key: K): Bool;

	/**
		Finds the first key-value pair that matches `key`, removes it and returns the value.
		`key` must be present in the registered data.
		@return The mapped value.
	**/
	function removeGet(key: K): V;

	/**
		Removes the first key-value pair that matches `key` and returns the value.
		@return The mapped value. `null` if not found.
	**/
	function tryRemoveGet(key: K): Null<V>;

	/**
		Removes the first key-value pair that matches `key` and
		applies `callback` to the removing key-value pair.
		No effect if `key` is absent.
	**/
	function removeApply(key: K, callback: (key: K, value: V) -> Void): Void;

	/**
		Removes all key-value pairs that match `key`.
		@return `true` if any found and removed.
	**/
	function removeAll(key: K): Bool;
}
