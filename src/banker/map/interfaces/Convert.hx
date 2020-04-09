package banker.map.interfaces;

interface Convert<K, V> {
	/**
		@return New vector containing all keys of `this`.
	**/
	function exportKeys(): Vector<K>;

	/**
		@return New vector containing all values of `this`.
	**/
	function exportValues(): Vector<V>;

	/**
		Creates a new assosiative array with:
		- Same keys as `this`
		- Converted values from `this`
	**/
	function mapValues<W>(convertValue: (key: K, value: V) -> W): Convert<K, W>;
}
