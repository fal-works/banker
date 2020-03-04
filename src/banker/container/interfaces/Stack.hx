package banker.container.interfaces;

interface Stack<T> {
	function push(value: T): Void;
	function pop(): T;
}
