package banker.container;

import banker.container.buffer.top_aligned.*; // Necessary for spirits

/**
	Array-based set.
	Suited for iteration or holding small number of elements.
	The order is not preserved.
	Allows duplicates.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper.verified
@:ripper.spirits(
	buffer.top_aligned.features.Sequence,
	buffer.top_aligned.features.Set,
	buffer.top_aligned.constraints.Unordered,
	buffer.top_aligned.constraints.NotUnique
)
class ArrayMultiset<T>
	extends TopAlignedBuffer<T>
	implements banker.container.interfaces.Set<T>
	implements banker.container.interfaces.Sequence<T>
	implements ripper.Body {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayMultiset<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayMultiset<T>
		return TaggedExtension.newTag(this, name, bits);
}
