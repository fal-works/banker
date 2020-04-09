package banker.map.interfaces;

interface Map<K, V> {
	/**
		Gets value for `key`.
		`key` must be present in the registered data.
		@return The value that is mapped to `key`.
	**/
	function get(key: K): V;

	/**
		Gets value for `key`.
		@return The value that is mapped to `key`. If not found, `defaultValue`.
	**/
	function getOr(key: K, defaultValue: V): V;

	/**
		Gets value for `key`.
		@return The value that is mapped to `key`. If not found, the result from `valueFactory()`.
	**/
	function getOrElse(key: K, valueFactory: () -> V): V;

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
	 * Maps `key` to `value`.
	 * - If `key` already exists, the mapped value will be overwritten only if `predicate` returns `true`.
	 * - if `key` does not exist, adds a new key-value pair.
	 * @param predicate Function that returns `true` if the old value should be overwritten.
	 * @return The result of `predicate`, whether or not `newValue` is set by this operation.
	 */
	function setIf(
		key: K,
		newValue: V,
		predicate: (
			key: K,
			oldValue: V,
			newValue: V
		) -> Bool
	): Bool;

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
}
