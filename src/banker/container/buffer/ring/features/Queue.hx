package banker.container.buffer.ring.features;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Queue<T>
	extends RingBuffer<T>
	implements banker.container.interfaces.Queue<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Queue` **/
	public inline function enqueue(value: T): Void
		DequeExtension.pushBack(this, value);

	/** @see `banker.container.interfaces.Queue` **/
	public inline function dequeue(): T
		return DequeExtension.popFront(this);
}
