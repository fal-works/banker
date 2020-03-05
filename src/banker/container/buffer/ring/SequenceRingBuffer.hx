package banker.container.buffer.ring;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.container)
class SequenceRingBuffer<T> extends RingBuffer<T> implements Sequence<T> {
	public inline function forEach(callback: T->Void): Void
		SequenceExtension.forEach(this, callback);

	public inline function filter(predicate: T->Bool): Vector<T>
		return SequenceExtension.filter(this, predicate);

	public inline function map<S>(callback: T->S): Vector<S>
		return SequenceExtension.map(this, callback);
}
