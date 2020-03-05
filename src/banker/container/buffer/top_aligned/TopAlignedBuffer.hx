package banker.container.buffer.top_aligned;

import sneaker.common.UnsupportedOperationException;
import banker.common.internal.LimitedCapacityBuffer;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class TopAlignedBuffer<T> extends Tagged implements LimitedCapacityBuffer {
	/** @inheritdoc **/
	public var capacity(get, never): Int;

	/** @inheritdoc **/
	public var size(get, never): Int;

	/** The internal vector. **/
	final vector: WritableVector<T>;

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
		Clears `this` logically, i.e. the `size` is set to `0`
		but the references remain in the internal vector.
	**/
	public inline function clear(): Void {
		nextFreeSlotIndex = 0;
	}

	/**
		Clears `this` physically, i.e. the `size` is set to `0`
		and all references are explicitly nullified.
	**/
	public inline function clearPhysical(): Void {
		clear();
		vector.fill(cast null);
	}

	/** @inheritdoc **/
	public inline function getUsageRatio(): Float
		return size / capacity;

	/** @inheritdoc **/
	public inline function toString<T>(): String
		return vector.ref.joinIn(0, size, ", ");

	inline function get_capacity()
		return vector.length;

	inline function get_size(): Int
		return nextFreeSlotIndex;

	/**
		Internal method for removing element at `index` from `this`.

		`vector` and `currentSize` are likely already obtained from `this` before
		calling `removeAtInternal()`, therefore this method requires them to be
		passed as arguments rather than obtaining them again in this method.

		This method must be overridden by the concrete subclass.

		@param vector `this.vector`
		@param currentSize Current size of `this`, used for determining the last index.
		@param index Index of the element to be removed.
	**/
	function removeAtInternal(
		vector: WritableVector<T>,
		currentSize: Int,
		index: Int
	): T {
		throw new UnsupportedOperationException("This method must be overridden by the subclass.");
	}
}
