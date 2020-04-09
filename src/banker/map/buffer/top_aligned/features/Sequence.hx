package banker.map.buffer.top_aligned.features;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Sequence<K, V>
	extends TopAlignedBuffer<K, V>
	implements banker.map.interfaces.Sequence<K, V>
	implements ripper.Spirit {
	/** @see `banker.map.interfaces.Sequence` **/
	public inline function forEachKey(callback: (key: K) -> Void): Void
		SequenceExtension.forEachKey(this, callback);

	/** @see `banker.map.interfaces.Sequence` **/
	public inline function forEachValue(callback: (value: V) -> Void): Void
		SequenceExtension.forEachValue(this, callback);

	/** @see `banker.map.interfaces.Sequence` **/
	public inline function forEach(callback: (key: K, value: V) -> Void): Void
		SequenceExtension.forEach(this, callback);

	/** @see `banker.map.interfaces.Sequence` **/
	public inline function forEachIndex(
		callback: (
			index: Int,
			keys: WritableVector<K>,
			values: WritableVector<V>
		) -> Void
	): Void {
		SequenceExtension.forEachIndex(this, callback);
	}

	/** @see `banker.map.interfaces.Sequence` **/
	public inline function forFirst(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		return SequenceExtension.forFirst(this, predicate, callback);
	}
}
