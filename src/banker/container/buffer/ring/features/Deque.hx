package banker.container.buffer.ring.features;

#if !banker_generic_disable
@:generic
#end
class Deque<T>
	extends RingBuffer<T>
	implements banker.container.interfaces.Deque<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Deque` **/
	public inline function pushBack(value: T): Void
		DequeExtension.pushBack(this, value);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function popFront(): T
		return DequeExtension.popFront(this);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function pushFront(value: T): Void
		DequeExtension.pushFront(this, value);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function popBack(): T
		return DequeExtension.popBack(this);
}
