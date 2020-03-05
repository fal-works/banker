package banker.container;

// NOTE: Automatic static extension does not work on generic classes
import banker.container.buffer.top_aligned.*;

/**
	Array-based set.
	Suited for iteration or holding small number of elements.
	The order is not preserved.
	Does not allow duplicates.
**/
#if !banker_generic_disable
@:generic
#end
class ArraySet<T> extends TopAlignedSetBuffer<T> {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/**
		Adds `element` to `this`.
		Duplicates are not allowed; It has no effect if `element` already exists in `this`.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.pushInternal()`
	**/
	override inline function pushInternal(index: Int, element: T): Void {
		final vector = this.vector;
		if (!vector.ref.hasIn(element, 0, index)) {
			vector[index] = element;
			nextFreeSlotIndex = index + 1;
		}
	}

	/**
		Adds all elements in `vector` to `this`.
		Duplicates are not allowed; Only the elements that do not exist in `this` are pushed.
		O(n^2) complexity.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.pushFromVectorInternal()`
	**/
	override inline function pushFromVectorInternal(
		index: Int,
		otherVector: VectorReference<T>,
		otherVectorLength: Int
	): Void {
		final thisVector = this.vector;
		var readIndex = 0;
		var writeIndex = index;
		while (readIndex < otherVectorLength) {
			final element = otherVector[readIndex];
			if (!vector.ref.hasIn(element, 0, writeIndex)) {
				thisVector[writeIndex] = element;
				++writeIndex;
			}
			++readIndex;
		}
		this.nextFreeSlotIndex = writeIndex;
	}
}
