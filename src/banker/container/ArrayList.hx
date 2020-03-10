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
	buffer.top_aligned.OrderedSet,
	buffer.top_aligned.Ordered
)
class ArrayList<T>
	extends TopAlignedBuffer<T>
	implements List<T>
	implements ripper.Body {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function pushInternal(index: Int, element: T): Void
		InternalExtension.pushDuplicatesAllowed(this, index, element);

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function pushFromVectorInternal(
		index: Int,
		otherVector: VectorReference<T>,
		otherVectorLength: Int
	): Void {
		InternalExtension.pushFromVectorDuplicatesAllowed(
			this,
			index,
			otherVector,
			otherVectorLength
		);
	}

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayList<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayList<T>
		return TaggedExtension.newTag(this, name, bits);
}
