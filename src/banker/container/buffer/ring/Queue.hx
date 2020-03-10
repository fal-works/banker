package banker.container.buffer.ring;

import banker.container.buffer.ring.DequeExtension;

#if !banker_generic_disable
@:generic
#end
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
