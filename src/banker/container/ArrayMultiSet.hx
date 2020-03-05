package banker.container;

// NOTE: Automatic static extension does not work on generic classes
import banker.container.buffer.top_aligned.*;

/**
	Array-based set.
	Suited for iteration or holding small number of elements.
	The order is not preserved.
	Allows duplicates.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayMultiSet<T> extends TopAlignedSetBuffer<T> {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/**
		Adds `element` to `this`. Duplicates are allowed.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.pushInternal()`
	**/
	override inline function pushInternal(index: Int, element: T): Void {
		vector[index] = element;
		nextFreeSlotIndex = index + 1;
	}

	/**
		Adds all elements in `vector` to `this`.
		Duplicates are allowed.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.pushFromVectorInternal()`
	**/
	override inline function pushFromVectorInternal(
		index: Int,
		otherVector: VectorReference<T>,
		otherVectorLength: Int
	): Void {
		VectorTools.blit(otherVector, 0, this.vector, index, otherVectorLength);
		this.nextFreeSlotIndex = index + otherVectorLength;
	}
}
