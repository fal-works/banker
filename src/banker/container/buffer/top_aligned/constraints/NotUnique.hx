package banker.container.buffer.top_aligned.constraints;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class NotUnique<T> extends TopAlignedBuffer<T> implements ripper.Spirit {
	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function pushInternal(index: UInt, element: T): Void
		InternalExtension.pushDuplicatesAllowed(this, index, element);

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.pushFromVectorInternal()`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function pushFromVectorInternal(
		index: UInt,
		otherVector: VectorReference<T>,
		otherVectorLength: UInt
	): Void {
		InternalExtension.pushFromVectorDuplicatesAllowed(
			this,
			index,
			otherVector,
			otherVectorLength
		);
	}
}
