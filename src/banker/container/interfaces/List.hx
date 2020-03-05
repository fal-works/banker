package banker.container.interfaces;

interface List<T> extends Indexed<T> extends Sequence<T> extends Set<T> {
	function add(value: T): Void;
}
