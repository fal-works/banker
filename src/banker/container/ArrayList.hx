package banker.container;

import banker.container.buffer.top_aligned.*; // Necessary for spirits

/**
	Array-based stack.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper_verified
@:ripper_spirits(
	buffer.top_aligned.features.Indexed,
	buffer.top_aligned.features.Sequence,
	buffer.top_aligned.features.Set,
	buffer.top_aligned.constraints.Ordered,
	buffer.top_aligned.constraints.NotUnique
)
class ArrayList<T>
	extends TopAlignedBuffer<T>
	implements Indexed<T>
	implements Sequence<T>
	implements Set<T>
	implements ripper.Body {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayList<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayList<T>
		return TaggedExtension.newTag(this, name, bits);
}
