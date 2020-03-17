package banker.container;

import banker.container.buffer.ring.*; // Necessary for spirits

/**
	Array-based queue.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper.verified
@:ripper.spirits(buffer.ring.features.Queue, buffer.ring.features.Sequence)
class ArrayQueue<T>
	extends RingBuffer<T>
	implements Queue<T>
	implements Sequence<T>
	implements ripper.Body {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayQueue<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayQueue<T>
		return TaggedExtension.newTag(this, name, bits);
}
