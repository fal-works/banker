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
class ArraySet<T> extends TopAlignedSetBuffer<T> implements Sequence<T> {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see banker.container.buffer.top_aligned.CloneExtension **/
	public inline function cloneAsSet(newCapacity = -1): ArraySet<T>
		return CloneExtension.cloneAsSet(this, newCapacity);

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function pushInternal(index: Int, element: T): Void
		InternalExtension.pushDuplicatesPrevented(this, index, element);

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
		InternalExtension.pushFromVectorDuplicatesPrevented(
			this,
			index,
			otherVector,
			otherVectorLength
		);
	}
}
