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
	override inline function pushInternal(index: UInt, element: T): Void
		InternalExtension.pushDuplicatesPrevented(this, index, element);

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
	**/
	override inline function pushFromVectorInternal(
		index: UInt,
		otherVector: VectorReference<T>,
		otherVectorLength: UInt
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
	public inline function cloneAsSet(newCapacity = MaybeUInt.none): ArraySet<T>
		return CloneExtension.cloneAsSet(this, newCapacity);
}
