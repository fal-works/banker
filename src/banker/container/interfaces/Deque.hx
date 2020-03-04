package banker.container.interfaces;

interface Deque<T> {
	function pushBack(value: T): Void;
	function popFront(): T;
	function pushFront(value: T): Void;
	function popBack(): T;
}
