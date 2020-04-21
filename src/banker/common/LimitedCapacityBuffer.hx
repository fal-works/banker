package banker.common;

import sneaker.tag.interfaces.Tagged;
import banker.watermark.Percentage;

/**
	Data collection objects that have limited capacities.
**/
@:using(banker.watermark.TaggedExtension)
interface LimitedCapacityBuffer extends Tagged {
	/** Max number of elements `this` can contain. **/
	var capacity(get, never): UInt;

	/** Current number of elements. **/
	var size(get, never): UInt;

	/**
		Clears `this` logically.
	**/
	function clear(): Void;

	/**
		Clears `this` physically.
	**/
	function clearPhysical(): Void;

	/**
		@return Current usage ratio.
	**/
	function getUsageRatio(): Percentage;

	/**
		@return A `String` representation of `this`.
	**/
	function toString(): String;
}
