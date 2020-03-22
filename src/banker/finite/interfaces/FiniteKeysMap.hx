package banker.finite.interfaces;

interface FiniteKeysMap<K, V> {
	function get(key: K): V;
	function getter(key: K): () -> V;

	function set(key: K, value: V): V;
	function setter(key: K): (value: V) -> Void;
}
