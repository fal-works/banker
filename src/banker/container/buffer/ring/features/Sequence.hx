package banker.container.buffer.ring.features;

#if !banker_generic_disable
@:generic
#end
@:ripper.verified
class Sequence<T>
	extends RingBuffer<T>
	implements banker.container.interfaces.Sequence<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Sequence` **/
	public inline function forEach(callback: T->Void): Void
		SequenceExtension.forEach(this, callback);

	/** @see `banker.container.interfaces.Sequence` **/
	public inline function filter(predicate: T->Bool): Vector<T>
		return SequenceExtension.filter(this, predicate);

	/** @see `banker.container.interfaces.Sequence` **/
	public inline function map<S>(callback: T->S): Vector<S>
		return SequenceExtension.map(this, callback);
}
