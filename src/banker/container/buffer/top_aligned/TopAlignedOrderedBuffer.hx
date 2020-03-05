package banker.container.buffer.top_aligned;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class TopAlignedOrderedBuffer<T> extends TopAlignedBuffer<T> {
	/**
		Removes the element at `index` by shifting all elements at succeeding
		indices towards index zero (thus the order is preserved).
		O(n) complexity.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
	**/
	override function removeAtInternal(
		vector: WritableVector<T>,
		currentSize: Int,
		index: Int
	): T {
		final removed = vector[index];
		vector.blitInternal(index + 1, index, size - 1 - index);
		this.nextFreeSlotIndex = size - 1;

		return removed;
	}
}
