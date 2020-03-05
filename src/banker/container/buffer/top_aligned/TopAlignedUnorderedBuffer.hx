package banker.container.buffer.top_aligned;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class TopAlignedUnorderedBuffer<T> extends TopAlignedBuffer<T> {
	/**
		Removes the element at `index` by overwriting it with that at the last index
		(thus the order is not preserved).
		O(1) complexity.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
	**/
	override function removeAtInternal(
		vector: WritableVector<T>,
		currentSize: Int,
		index: Int
	): T {
		final removed = vector[index];

		final lastIndex = size - 1;
		vector[index] = vector[lastIndex];
		this.nextFreeSlotIndex = lastIndex;

		return removed;
	}
}
