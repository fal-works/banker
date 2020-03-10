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

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayQueue<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayQueue<T>
		return TaggedExtension.newTag(this, name, bits);
}
