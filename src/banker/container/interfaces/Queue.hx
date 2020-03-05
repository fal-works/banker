package banker.container.interfaces;

interface Queue<T> extends Sequence<T> {
	/**
		Adds `value` as the back/last/newest element of `this`.
		Duplicates are allowed.
	**/
	function enqueue(value: T): Void;

	/**
	 * Removes the front/top/oldest element from `this`.
	 * @return Removed element.
	 */
	function dequeue(): T;
}
