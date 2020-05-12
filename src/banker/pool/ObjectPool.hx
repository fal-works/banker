package banker.pool;

import sneaker.tag.Tag;
import sneaker.tag.TaggedExtension;
import banker.container.buffer.top_aligned.StackExtension;

/**
	Array-based object pool.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class ObjectPool<T> extends ObjectPoolBase<T> {
	/**
		Gets an element that is currently not in use.
		Raises an exception if `this` is empty.
	**/
	override public inline function get(): T
		return StackExtension.pop(this);

	/**
		Puts an element to `this` so that it can be used later again.
		Raises an exception if `this` is full.
	**/
	override public inline function put(element: T): Void
		return StackExtension.push(this, element);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	override public function setTag(tag: Tag): ObjectPool<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	override public function newTag(name: String, ?bits: Int): ObjectPool<T>
		return TaggedExtension.newTag(this, name, bits);
}
