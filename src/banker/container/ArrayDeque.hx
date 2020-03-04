package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.buffer.ring.*;

/**
	Array-based deque.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayDeque<T> extends SequenceRingBuffer<T> implements Deque<T> {
	public function new(capacity: Int)
		super(capacity);

	public inline function pushBack(element: T): Void
		DequeExtension.pushBack(this, element);

	public inline function popFront(): T
		return DequeExtension.popFront(this);

	public inline function pushFront(element: T): Void
		DequeExtension.pushFront(this, element);

	public inline function popBack(): T
		return DequeExtension.popBack(this);
}
