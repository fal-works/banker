package banker.container.internal;

import banker.vector.WritableVector;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class ArrayBase<T> extends Tagged {
	/** Max number of elements `this` can contain. **/
	public var capacity(get, never): Int;

	/** Current number of elements. **/
	public var size(get, never): Int;

	/** The internal vector. **/
	var vector: WritableVector<T>;

	/** The index indicating the free slot for putting next element. **/
	var nextFreeSlotIndex: Int = 0;

	/**
		@param capacity Max number of elements `this` can contain.
	**/
	function new(capacity: Int) {
		assert(capacity >= 0);
		super();

		this.vector = new WritableVector(capacity);
	}

	/**
		@return Current usage ratio between 0 and 1.
	**/
	public inline function getUsageRatio(): Float
		return size / capacity;

	inline function get_capacity()
		return vector.length;

	inline function get_size(): Int
		return nextFreeSlotIndex;
}
