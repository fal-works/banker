package banker.pool;

import sneaker.tag.TaggedExtension;
import banker.container.buffer.top_aligned.TopAlignedBuffer;
import banker.container.buffer.top_aligned.StackExtension;
import banker.container.buffer.top_aligned.InternalExtension; // Necessary for spirits
import banker.vector.*; // Necessary for spirits

/**
	Array-based object pool.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper.verified
@:ripper.spirits(banker.container.buffer.top_aligned.constraints.Unordered)
@:ripper.spirits(banker.container.buffer.top_aligned.constraints.NotUnique)
class ObjectPool<T> extends TopAlignedBuffer<T> implements ripper.Body {
	/**
		Creates an object pool populated with elements made by `factory()`.
	**/
	public function new(capacity: Int, factory: () -> T) {
		super(capacity);
		final elements = Vector.createPopulated(capacity, factory);
		StackExtension.pushFromVector(this, elements);
	}

	/**
		Gets an element that is currently not in use.
		Raises an exception if `this` is empty.

		Override this method to add any safety checks or
		any initialization process for the instance.
	**/
	public function get(): T
		return StackExtension.pop(this);

	/**
		Puts an element to `this` so that it can be used later again.
		Raises an exception if `this` is full.

		Override this method to add any safety checks or
		any initialization process for the instance.
	**/
	public function put(element: T): Void
		return StackExtension.push(this, element);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag): ObjectPool<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name, bits): ObjectPool<T>
		return TaggedExtension.newTag(this, name, bits);
}
