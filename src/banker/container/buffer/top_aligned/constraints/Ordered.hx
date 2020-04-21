package banker.container.buffer.top_aligned.constraints;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Ordered<T> extends TopAlignedBuffer<T> implements ripper.Spirit {
	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function removeAtInternal(
		vector: WritableVector<T>,
		currentSize: UInt,
		index: UInt
	): T {
		return InternalExtension.removeShiftAt(this, vector, currentSize, index);
	}

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function removeAllInternal(predicate: (value: T) -> Bool): Bool
		return InternalExtension.removeShiftAll(this, predicate);
}
