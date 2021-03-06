package banker.pool;

import sneaker.tag.Tag;
import sneaker.tag.TaggedExtension;

/**
	"Safe" version of `ObjectPool<T>` with `size`/`capacity` checks in every `get()`/`put()` call.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class SafeObjectPool<T> extends ObjectPoolBase<T> {
	/**
		Factory function for additionally creating new instances in case `this` is empty.
	**/
	public var factory: () -> T;

	/** @inheritdoc **/
	public function new(capacity: UInt, factory: () -> T) {
		super(capacity, factory);
		this.factory = factory;
	}

	/**
		Gets an element that is currently not in use.

		If `this` is empty, creates a new instance and also
		outputs DEBUG log if enabled (see `sneaker` library about logging).
	**/
	override public function get(): T
		return if (!this.size.isZero()) super.get() else {
			this.debug("Empty. Create new instance.");
			factory();
		}

	/**
		Puts an element to `this` so that it can be used later again.

		Ignores if `this` is already full and also outputs DEBUG log
		if enabled (see `sneaker` library about logging).
	**/
	override public function put(element: T): Void
		if (this.size < this.capacity)
			super.put(element);
		else
			this.debug("Already full.");

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	override public function setTag(tag: Tag): SafeObjectPool<T>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	override public function newTag(name: String, ?bits: Int): SafeObjectPool<T>
		return TaggedExtension.newTag(this, name, bits);
}
