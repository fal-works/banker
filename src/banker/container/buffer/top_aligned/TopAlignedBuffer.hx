package banker.container.buffer.top_aligned;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class TopAlignedBuffer<T> extends Tagged implements Buffer {
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
		Clears `this` logically, i.e. the `size` is set to `0`
		but the references remains in the internal vector.
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

	/**
		@return Current usage ratio between 0 and 1.
	**/
	public inline function getUsageRatio(): Float
		return size / capacity;

	/**
		@return A `String` representation of `this`.
	**/
	public inline function toString<T>(): String {
		return vector.ref.joinIn(0, size, ", ");
	}

	inline function get_capacity()
		return vector.length;

	inline function get_size(): Int
		return nextFreeSlotIndex;
}
