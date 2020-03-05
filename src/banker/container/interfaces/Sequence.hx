package banker.container.interfaces;

interface Sequence<T> {
	/**
		Runs `callback` for each element of `this`.
	**/
	function forEach(callback: T->Void): Void;

	/**
		Filters elements of `this` by `predicate`.
		@param predicate Function that returns true if the given element meets the condition.
		@return New vector with filtered elements.
	**/
	function filter(predicate: T->Bool): Vector<T>;

	/**
		Maps element of `this` by converting with `callback`.
		@param callback Function that converts the given element to another value.
		@return New vector with mapped elements.
	**/
	function map<S>(callback: T->S): Vector<S>;
}
