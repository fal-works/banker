package banker.linker.buffer.top_aligned.constraints;

#if !banker_generic_disable
@:generic
#end
@:ripper.verified
class Ordered<K, V> extends TopAlignedBuffer<K, V> implements ripper.Spirit {
	/**
		@see `banker.linker.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
		@see `banker.linker.buffer.top_aligned.InternalExtension`
	**/
	override inline function removeAtInternal(
		keyVector: WritableVector<K>,
		valueVector: WritableVector<V>,
		currentSize: Int,
		index: Int
	): Void {
		InternalExtension.removeShiftAt(
			this,
			keyVector,
			valueVector,
			currentSize,
			index
		);
	}

	/**
		@see `banker.linker.interfaces.Set`
		@see `banker.linker.buffer.top_aligned.InternalExtension`
	**/
	override inline function removeAllInternal(
		predicate: (key: K, value: V) -> Bool
	): Bool {
		return InternalExtension.removeShiftAll(this, predicate);
	}

	/**
		@see `banker.linker.interfaces.Set`
		@see `banker.linker.buffer.top_aligned.InternalExtension`
	**/
	override inline function removeApplyAllInternal(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		return InternalExtension.removeShiftApplyAll(this, predicate, callback);
	}
}
