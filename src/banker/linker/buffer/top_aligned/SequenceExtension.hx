package banker.linker.buffer.top_aligned;

class SequenceExtension {
	/** @see `buffer.linker.interfaces.Sequence` **/
	public static inline function forEachKey<K, V>(
		_this: TopAlignedBuffer<K, V>,
		callback: K->Void
	): Void {
		_this.keyVector.ref.forEachIn(callback, 0, _this.size);
	}

	/** @see `buffer.linker.interfaces.Sequence` **/
	public static inline function forEachValue<K, V>(
		_this: TopAlignedBuffer<K, V>,
		callback: V->Void
	): Void {
		_this.valueVector.ref.forEachIn(callback, 0, _this.size);
	}

	/** @see `buffer.linker.interfaces.Sequence` **/
	public static inline function forEach<K, V>(
		_this: TopAlignedBuffer<K, V>,
		callback: K->V->Void
	): Void {
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final len = _this.size;
		var i = 0;
		while (i < len) {
			callback(keys[i], values[i]);
			++i;
		}
	}

	/** @see `buffer.linker.interfaces.Sequence` **/
	public static inline function forEachIndex<K, V>(
		_this: TopAlignedBuffer<K, V>,
		callback: (
			index: Int,
			keys: WritableVector<K>,
			values: WritableVector<V>
		) -> Void
	): Void {
		final keys = _this.keyVector;
		final values = _this.valueVector;
		final len = _this.size;
		var i = 0;
		while (i < len) {
			callback(i, keys, values);
			++i;
		}
	}
}
