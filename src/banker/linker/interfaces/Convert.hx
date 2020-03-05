package banker.linker.interfaces;

interface Convert<K, V> {
	/**
		@return New vector containing all keys of `this`.
	**/
	function exportKeys<K, V>(): Vector<K>;

	/**
		@return New vector containing all values of `this`.
	**/
	function exportValues(): Vector<V>;

	/**
		Creates a new assosiative array with:
		- Same keys as `this`
		- Converted values from `this`
	**/
	function mapValues<W>(convertValue: V->W): Convert<K, W>;
}
