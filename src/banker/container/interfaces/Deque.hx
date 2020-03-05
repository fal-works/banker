package banker.container.interfaces;

interface Deque<T> extends Sequence<T> {
	/**
		Adds `value` as the back/last/newest element of `this`.
		Duplicates are allowed.
		Same as `Queue.enqueue()`.
	**/
	function pushBack(value: T): Void;

	/**
		Removes the front/top/oldest element from `this`.
		Same as `Queue.dequeue()`.
		@return Removed element.
	**/
	function popFront(): T;

	/**
		Adds `value` as the front/top element of `this`.
		Duplicates are allowed.
	**/
	function pushFront(value: T): Void;

	/**
		Removes the back/last element from `this`.
		@return Removed element.
	**/
	function popBack(): T;
}
