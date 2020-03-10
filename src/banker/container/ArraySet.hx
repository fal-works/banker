package banker.container;

import banker.container.buffer.top_aligned.*; // Necessary for spirits

/**
	Array-based set.
	Suited for iteration or holding small number of elements.
	The order is not preserved.
	Does not allow duplicates.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper.spirits(
	buffer.top_aligned.features.Sequence,
	buffer.top_aligned.features.Set,
	buffer.top_aligned.constraints.Unordered,
	buffer.top_aligned.constraints.Unique
)
class ArraySet<T>
	extends TopAlignedBuffer<T>
	implements Set<T>
	implements Sequence<T>
	implements ripper.Body {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see banker.container.buffer.top_aligned.CloneExtension **/
	public inline function cloneAsSet(newCapacity = -1): ArraySet<T>
		return CloneExtension.cloneAsSet(this, newCapacity);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArraySet<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArraySet<T>
		return TaggedExtension.newTag(this, name, bits);
}
