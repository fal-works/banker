package banker.container.buffer.top_aligned.constraints;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Unique<T> extends TopAlignedBuffer<T> implements ripper.Spirit {
	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function pushInternal(index: Int, element: T): Void
		InternalExtension.pushDuplicatesPrevented(this, index, element);

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
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

	/**
		@see `banker.container.buffer.top_aligned.CloneExtension`
	**/
	public inline function cloneAsSet(newCapacity = -1): ArraySet<T>
		return CloneExtension.cloneAsSet(this, newCapacity);
}
