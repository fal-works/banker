package banker.container.interfaces;

interface List<T> extends Indexed<T> extends Sequence<T> {
	function add(value: T): Void;
}
