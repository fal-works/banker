package banker.linker.interfaces;

interface GetSet<K, V> {
	/**
		Gets value for `key`.
		`key` must be present in the registered data.
		@return The value that is mapped to `key`.
	**/
	function get(key: K): V;

	/**
		Gets value for `key`.
		@return The value that is mapped to `key`. `null` if `key` does not exist.
	**/
	function tryGet(key: K): Null<V>;

	/**
		Maps `key` to `value`.
		If `key` already exists, the mapped value is overwritten.
		If not, adds a new key-value pair.
		@return `true` if `key` is newly added by this operation.
	**/
	function set(key: K, value: V): Bool;

	/**
		Maps `key` to `value` only if `key` does not exist.
		@return `true` if `key` is newly added by this operation.
	**/
	function setIfAbsent(key: K, value: V): Bool;

	/**
		Returns the value that is mapped to `key`.
		If not found, adds a new pair of `key` and `defaultValue`, and returns `defaultValue`.
	**/
	function getOrAdd(key: K, defaultValue: V): V;

	/**
		Returns the value that is mapped to `key`.
		If not found, creates new value with `valueFactory`,
		adds the new key-value pair and returns the created value.
	**/
	function getOrAddWith(key: K, valueFactory: K->V): V;

	/**
		Checks if `this` has `key`.
		@return `true` if found.
	**/
	function hasKey(key: K): Bool;
}
