package banker.map.buffer.top_aligned.constraints;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Ordered<K, V> extends TopAlignedBuffer<K, V> implements ripper.Spirit {
	/**
		@see `banker.map.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
		@see `banker.map.buffer.top_aligned.InternalExtension`
	**/
	override inline function removeAtInternal(
		keyVector: WritableVector<K>,
		valueVector: WritableVector<V>,
		currentSize: UInt,
		index: UInt
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
		@see `banker.map.interfaces.Set`
		@see `banker.map.buffer.top_aligned.InternalExtension`
	**/
	override inline function removeAllInternal(
		predicate: (key: K, value: V) -> Bool
	): Bool {
		return InternalExtension.removeShiftAll(this, predicate);
	}

	/**
		@see `banker.map.interfaces.Set`
		@see `banker.map.buffer.top_aligned.InternalExtension`
	**/
	override inline function removeApplyAllInternal(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		return InternalExtension.removeShiftApplyAll(this, predicate, callback);
	}
}
