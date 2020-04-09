package banker.pool;

import sneaker.tag.TaggedExtension;
import banker.container.buffer.top_aligned.StackExtension;

/**
	An alternative kind of object pool which itself is the primary collector of objects in use,
	instead of having `put()` method for receiving discarded objects.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class ObjectLender<T> extends ObjectPoolBuffer<T> {
	/**
		Gets an element that is currently not in use.
		Raises an exception if `this` is empty.

		Note that you should not use the lent element any more after it is collected by `this`.
	**/
	public inline function lend(): T
		return StackExtension.pop(this);

	/**
		Collects the last `n` objects that were most recently lent by `lend()` and are currently in use,
		so that they can be lent again in other places.

		Be sure to stop using the objects that are going to be collected.
	**/
	public inline function collect(n: Int): Void {
		final nextSize = this.size + n;
		#if !macro
		assert(nextSize <= this.capacity);
		#end
		this.setSize(nextSize); // Assuming that the internal vector has not been changed
	}

	/**
		Collects the last object that was most recently lent by `lend()` and is currently in use,
		so that it can be lent again in another place.

		Be sure to stop using the object that is going to be collected.
	**/
	public inline function collectLast(): Void
		this.collect(1);

	/**
		Collects all lent objects so that they can be lent again.

		Be sure to stop using all lent objects.
	**/
	public inline function collectAll(): Void
		this.setSize(this.capacity);

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag): ObjectLender<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name, bits): ObjectLender<T>
		return TaggedExtension.newTag(this, name, bits);
}
