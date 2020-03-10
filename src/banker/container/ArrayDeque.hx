package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.buffer.ring.*;

/**
	Array-based deque.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper.spirits(buffer.ring.Deque)
class ArrayDeque<T>
	extends SequenceRingBuffer<T>
	implements banker.container.interfaces.Deque<T>
	implements ripper.Body {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayDeque<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayDeque<T>
		return TaggedExtension.newTag(this, name, bits);
}
