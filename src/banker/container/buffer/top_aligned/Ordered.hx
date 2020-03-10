package banker.container.buffer.top_aligned;

import banker.container.buffer.top_aligned.InternalExtension;

#if !banker_generic_disable
@:generic
#end
class Ordered<T> extends TopAlignedBuffer<T> implements ripper.Spirit {
	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override function removeAtInternal(
		vector: WritableVector<T>,
		currentSize: Int,
		index: Int
	): T {
		return InternalExtension.removeShiftAt(this, vector, currentSize, index);
	}

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override function removeAllInternal(predicate: (value: T) -> Bool): Bool
		return InternalExtension.removeShiftAll(this, predicate);
}
