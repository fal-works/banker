package banker.container.interfaces;

interface Indexed<T> {
	function get(index: Int): T;
	function set(index: Int, value: T): T;
	function insertAt(index: Int, value: T): T;
	function removeAt(index: Int): T;
}
