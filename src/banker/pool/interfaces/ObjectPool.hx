package banker.pool.interfaces;

import banker.common.LimitedCapacityBuffer;

interface ObjectPool<T> extends LimitedCapacityBuffer {
	/**
		Callback function for `this.put()`.
	**/
	final putCallback: (element: T) -> Void;

	/**
		Gets an element that is currently not in use.
	**/
	function get(): T;

	/**
		Puts an element to `this` so that it can be used later again.
	**/
	function put(element: T): Void;
}
