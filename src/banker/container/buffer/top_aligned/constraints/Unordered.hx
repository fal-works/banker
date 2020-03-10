package banker.container.buffer.top_aligned.constraints;

#if !banker_generic_disable
@:generic
#end
class Unordered<T> extends TopAlignedBuffer<T> implements ripper.Spirit {
	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override function removeAtInternal(
		vector: WritableVector<T>,
		currentSize: Int,
		index: Int
	): T {
		return InternalExtension.removeSwapAt(this, vector, currentSize, index);
	}

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override function removeAllInternal(predicate: (value: T) -> Bool): Bool
		return InternalExtension.removeSwapAll(this, predicate);
}
