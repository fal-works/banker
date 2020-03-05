package banker.container.interfaces;

interface Stack<T> {
	/**
		Adds `element` to `this`.
		Duplicates are allowed.
	**/
	function push(value: T): Void;

	/**
		Removes the most recently added element.
		@return Removed element.
	**/
	function pop(): T;

	/**
		@return The most recently added element.
	**/
	function peek(): T;

	/**
		Adds all elements in `vector` to `this`.
		Duplicates are allowed.
	**/
	function pushFromVector(vector: VectorReference<T>): Void;
}
