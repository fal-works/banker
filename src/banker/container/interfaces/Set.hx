package banker.container.interfaces;

import banker.linker.ArrayMap;

interface Set<T> {
	/**
		Adds `value` to `this`.
	**/
	function add(value: T): Void;

	/**
		Adds all elements in `otherVector` to `this`.
	**/
	function addFromVector(otherVector: VectorReference<T>): Void;

	/**
		@return The first found element that matches `predicate`. If not found, `defaultValue`.
	**/
	function findFirst(predicate: (element: T) -> Bool, defaultValue: T): T;

	/**
		Finds and removes `value` from `this`.
		@return `true` if found and removed.
	**/
	function remove(value: T): Bool;

	/**
		Removes all elements that match `predicate`.
		@return `true` if any found and removed.
	**/
	function removeAll(predicate: (element: T) -> Bool): Bool;

	/**
		@return `true` if `this` contains `value`.
	**/
	function has(value: T): Bool;

	/**
		@return `ture` if `this` contains any element that matches `predicate`.
	**/
	function hasAny(predicate: (element: T) -> Bool): Bool;

	/**
		@return The number of elements in `this` that match to `predicate`.
	**/
	function count(predicate: (element: T) -> Bool): Int;

	/**
		Groups all elements of `this` using `grouperCallback` and
		counts how many elements belong to each group.
		@return A map with element groups as keys and numbers of elements as values.
	**/
	function countAll<S>(grouperCallback: (element: T) -> S): ArrayMap<S, Int>;
}
