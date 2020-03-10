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
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function pushBack(element: T): Void
		DequeExtension.pushBack(this, element);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function popFront(): T
		return DequeExtension.popFront(this);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function pushFront(element: T): Void
		DequeExtension.pushFront(this, element);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function popBack(): T
		return DequeExtension.popBack(this);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayDeque<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayDeque<T>
		return TaggedExtension.newTag(this, name, bits);
}
