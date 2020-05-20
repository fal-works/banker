package banker.pool.interfaces;

import banker.common.LimitedCapacityBuffer;

/**
	An alternative kind of object pool which itself is the primary collector of objects in use,
	instead of having `put()` method for receiving discarded objects.
**/
interface ObjectLender<T> extends LimitedCapacityBuffer {
	/**
		Gets an element that is currently not in use.
		Raises an exception if `this` is empty.

		Note that you should not use the lent element any more after it is collected by `this`.
	**/
	function lend(): T;

	/**
		Collects the last `n` objects that were most recently lent by `lend()` and are currently in use,
		so that they can be lent again in other places.

		Be sure to stop using the objects that are going to be collected.
	**/
	function collect(n: UInt): Void;

	/**
		Collects the last object that was most recently lent by `lend()` and is currently in use,
		so that it can be lent again in another place.

		Be sure to stop using the object that is going to be collected.
	**/
	function collectLast(): Void;

	/**
		Collects all lent objects so that they can be lent again.

		Be sure to stop using all lent objects.
	**/
	function collectAll(): Void;
}
