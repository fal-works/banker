package banker.common.internal;

interface LimitedCapacityBuffer {
	/** Max number of elements `this` can contain. **/
	var capacity(get, never): Int;

	/** Current number of elements. **/
	var size(get, never): Int;

	/**
		Clears `this` logically.
	**/
	function clear(): Void;

	/**
		Clears `this` physically.
	**/
	function clearPhysical(): Void;

	/**
		@return Current usage ratio between 0 and 1.
	**/
	function getUsageRatio(): Float;
}
