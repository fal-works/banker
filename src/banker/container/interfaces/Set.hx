package banker.container.interfaces;

interface Set<T> extends Sequence<T> {
	function add(value: T): Void;
	function remove(value: T): Bool;
	function removeAll(predicate: (element: T) -> Bool): Bool;
	function has(value: T): Bool;
}
