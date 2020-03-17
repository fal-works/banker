package banker.container;

import banker.container.buffer.top_aligned.*; // Necessary for spirits

/**
	Array-based stack.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper.verified
@:ripper.spirits(
	buffer.top_aligned.features.Stack,
	buffer.top_aligned.constraints.Ordered,
	buffer.top_aligned.constraints.NotUnique
)
class ArrayStack<T>
	extends TopAlignedBuffer<T>
	implements Stack<T>
	implements ripper.Body {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayStack<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayStack<T>
		return TaggedExtension.newTag(this, name, bits);
}
