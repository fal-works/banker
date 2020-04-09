package banker.pool;

import sneaker.tag.TaggedExtension;
import banker.container.buffer.top_aligned.StackExtension;

/**
	Base class for array-based object pool classes with `get()`/`put()` methods.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class ObjectPoolBase<T> extends ObjectPoolBuffer<T> {
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
	public function setTag(tag): ObjectPoolBase<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name, bits): ObjectPoolBase<T>
		return TaggedExtension.newTag(this, name, bits);
}
