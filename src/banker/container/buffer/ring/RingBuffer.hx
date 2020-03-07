package banker.container.buffer.ring;

import banker.common.internal.LimitedCapacityBuffer;
import banker.watermark.Percentage;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class RingBuffer<T> extends Tagged implements LimitedCapacityBuffer {
	/** @inheritdoc **/
	public var capacity(get, never): Int;

	/** @inheritdoc **/
	public var size(get, never): Int;

	/** The internal vector. **/
	final vector: WritableVector<T>;

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
		but the references remain in the internal vector.
	**/
	public inline function clear(): Void {
		headIndex = 0;
		tailIndex = 0;
		setSize(0);
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
	public inline function getUsageRatio(): Percentage
		return size / capacity;

	/** @inheritdoc **/
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
			former + ", " + latter;
		}
	}

	inline function get_capacity()
		return vector.length;

	inline function get_size(): Int
		return internalSize;

	/**
		Internal method for setting the current size of `this`.

		This also calls `setWatermark()` if watermark mode is enabled.
		Set `this.internalSize` directly for avoiding this.
	**/
	inline function setSize(size: Int): Void {
		this.internalSize = size;
		#if banker_watermark_enable
		this.setWatermark(size / this.capacity);
		#end
	}
}
