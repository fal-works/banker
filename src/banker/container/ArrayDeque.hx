package banker.container;

import banker.container.buffer.ring.*; // Necessary for spirits

/**
	Array-based deque.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper_verified
@:ripper_spirits(buffer.ring.features.Deque, buffer.ring.features.Sequence)
class ArrayDeque<T>
	extends RingBuffer<T>
	implements Deque<T>
	implements Sequence<T>
	implements ripper.Body {
	/** @inheritdoc **/
	public function new(capacity: UInt)
		super(capacity);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayDeque<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayDeque<T>
		return TaggedExtension.newTag(this, name, bits);
}
