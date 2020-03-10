package banker.container.buffer.top_aligned;

import sneaker.exception.NotOverriddenException;
import banker.common.LimitedCapacityBuffer;
import banker.common.MathTools.minInt;
import banker.watermark.Percentage;

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
		setSize(0);
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
	public inline function toString<T>(): String
		return vector.ref.joinIn(0, size, ", ");

	/** @see banker.container.buffer.top_aligned.CloneExtension **/
	public inline function cloneAsList(newCapacity = -1): ArrayList<T>
		return CloneExtension.cloneAsList(this, newCapacity);

	/** @see banker.container.buffer.top_aligned.CloneExtension **/
	public inline function cloneAsStack(newCapacity = -1): ArrayStack<T>
		return CloneExtension.cloneAsStack(this, newCapacity);

	/** @see banker.container.buffer.top_aligned.CloneExtension **/
	public inline function cloneAsMultiset(newCapacity = -1): ArrayMultiset<T>
		return CloneExtension.cloneAsMultiset(this, newCapacity);

	inline function get_capacity()
		return vector.length;

	inline function get_size(): Int
		return nextFreeSlotIndex;

	/**
		Internal method for setting the current size of `this`.

		This also calls `setWatermark()` if watermark mode is enabled.
		Set `this.nextFreeSlotIndex` directly for avoiding this.
	**/
	inline function setSize(size: Int): Void {
		this.nextFreeSlotIndex = size;
		#if banker_watermark_enable
		this.setWatermark(size / this.capacity);
		#end
	}

	/**
		Overwrites `this` by copying elements from `other`.
		Overflowing data is truncated.

		Should only be used for cloning instance as
		this does not check uniqueness of elements.
	**/
	inline function blitAllFrom(other: TopAlignedBuffer<T>): Void {
		final length = minInt(this.capacity, other.size);
		VectorTools.blitZero(other.vector, this.vector, length);
		this.nextFreeSlotIndex = length;
		// do not update watermark as `this` is just created and has the same tag as `other`
	}

	/**
		Internal method for pushing `element` at `index`.

		`index` is already determined before calling `pushInternal()`,
		therefore this method requires it to be passed as argument rather than
		determining again in this method.

		This method must be overridden by the concrete subclass
		according to the specification e.g. whether to allow duplicates.
	**/
	function pushInternal(index: Int, element: T): Void {
		throw new NotOverriddenException();
	}

	/**
		Internal method for pushing elements from `otherVector` at `index`.

		`otherVectorLength` is already determined before calling `pushFromVectorInternal()`,
		therefore this method requires it to be passed as argument rather than
		determining again in this method.

		This method must be overridden by the concrete subclass
		according to the specification e.g. whether to allow duplicates.
	**/
	function pushFromVectorInternal(
		index: Int,
		otherVector: VectorReference<T>,
		otherVectorLength: Int
	): Void {
		throw new NotOverriddenException();
	}

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
		throw new NotOverriddenException();
	}

	/**
		Internal method for removing multiple elements.

		This method must be overridden by the concrete subclass.
		according to the specification e.g. whether to preserve order.
	**/
	function removeAllInternal(predicate: (value: T) -> Bool): Bool {
		throw new NotOverriddenException();
	}
}
