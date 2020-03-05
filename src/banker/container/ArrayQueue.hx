package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.buffer.ring.*;

/**
	Array-based queue.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayQueue<T> extends SequenceRingBuffer<T> implements Queue<T> {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `banker.container.interfaces.Queue` **/
	public inline function enqueue(element: T): Void
		QueueExtension.enqueue(this, element);

	/** @see `banker.container.interfaces.Queue` **/
	public inline function dequeue(): T
		return QueueExtension.dequeue(this);
}
