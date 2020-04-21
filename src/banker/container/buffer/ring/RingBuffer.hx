package banker.container.buffer.ring;

import banker.common.LimitedCapacityBuffer;
import banker.watermark.Percentage;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class RingBuffer<T> extends Tagged implements LimitedCapacityBuffer {
	/** @inheritdoc **/
	public var capacity(get, never): UInt;

	/** @inheritdoc **/
	public var size(get, never): UInt;

	/** The internal vector. **/
	final vector: WritableVector<T>;

	/** The index indicating the slot that holds the top element. **/
	var headIndex: UInt = UInt.zero;

	/** The index indicating the free slot for putting next element. **/
	var tailIndex: UInt = UInt.zero;

	/** The physical field for `size`. **/
	var internalSize: UInt = UInt.zero;

	/**
		@param capacity Max number of elements `this` can contain.
	**/
	function new(capacity: UInt) {
		super();

		this.vector = new WritableVector(capacity);
	}

	/**
		Clears `this` logically, i.e. the `size` is set to `0`
		but the references remain in the internal vector.
	**/
	public inline function clear(): Void {
		headIndex = UInt.zero;
		tailIndex = UInt.zero;
		setSize(UInt.zero);
	}

	/**
		Clears `this` physically, i.e. the `size` is set to `0`
		and all references are explicitly nullified.
	**/
	public inline function clearPhysical(): Void {
		clear();
		vector.fill(@:nullSafety(Off) cast null);
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
			final latter = vector.ref.joinIn(UInt.zero, tailIndex, ", ");
			former + ", " + latter;
		}
	}

	inline function get_capacity()
		return vector.length;

	inline function get_size()
		return internalSize;

	/**
		Internal method for setting the current size of `this`.

		This also calls `setWatermark()` if watermark mode is enabled.
		Set `this.internalSize` directly for avoiding this.
	**/
	inline function setSize(size: UInt): Void {
		this.internalSize = size;
		#if banker_watermark_enable
		this.setWatermark(size / this.capacity);
		#end
	}
}
