package banker.container.buffer.ring;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class RingBuffer<T> extends Tagged implements Buffer {
	/** Max number of elements `this` can contain. **/
	public var capacity(get, never): Int;

	/** Current number of elements. **/
	public var size(get, never): Int;

	/** The internal vector. **/
	var vector: WritableVector<T>;

	/** The index indicating the slot that holds the top element. **/
	var headIndex: Int = 0;

	/** The index indicating the free slot for putting next element. **/
	var tailIndex: Int = 0;

	/** The physical field for `size`. **/
	var internalSize: Int = 0;

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
		headIndex = 0;
		tailIndex = 0;
		internalSize = 0;
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
		@return A `String` representation of `this`.
	**/
	public inline function toString<T>(): String {
		final size = this.size;
		final headIndex = this.headIndex;
		final tailIndex = this.tailIndex;
		final vector = this.vector;
		final length = vector.length;

		return if (headIndex + size <= length)
			vector.ref.joinIn(headIndex, headIndex + size, ", ");
		else {
			final former = vector.ref.joinIn(headIndex, length, ", ");
			final latter = vector.ref.joinIn(0, tailIndex, ", ");
			former + latter;
		}
	}

	/**
		@return Current usage ratio between 0 and 1.
	**/
	public inline function getUsageRatio(): Float
		return size / capacity;

	inline function get_capacity()
		return vector.length;

	inline function get_size(): Int
		return internalSize;
}
