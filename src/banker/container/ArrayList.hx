package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.buffer.top_aligned.*;
import banker.linker.ArrayMap;

/**
	Array-based stack.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper.spirits(
	buffer.top_aligned.Indexed,
	buffer.top_aligned.Sequence,
	buffer.top_aligned.Set,
	buffer.top_aligned.Ordered,
	buffer.top_aligned.NotUnique
)
class ArrayList<T>
	extends TopAlignedBuffer<T>
	implements List<T>
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
