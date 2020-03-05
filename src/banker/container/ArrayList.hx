package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.buffer.top_aligned.*;

/**
	Array-based stack.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayList<T> extends TopAlignedOrderedBuffer<T> implements List<T> {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `banker.container.interfaces.List` **/
	public inline function add(value: T): Void
		StackExtension.push(this, value);

	/** @see `banker.container.interfaces.List` **/
	public inline function addFromVector(otherVector: VectorReference<T>): Void
		StackExtension.pushFromVector(this, otherVector);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function get(index: Int): T
		return IndexedExtension.get(this, index);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function set(index: Int, value: T): T
		return IndexedExtension.set(this, index, value);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function insertAt(index: Int, value: T): T
		return IndexedExtension.insertAt(this, index, value);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function removeAt(index: Int): T
		return IndexedExtension.removeAt(this, index);

	/** @see `banker.container.interfaces.Sequence` **/
	public inline function forEach(callback: T->Void): Void
		SequenceExtension.forEach(this, callback);

	/** @see `banker.container.interfaces.Sequence` **/
	public inline function filter(predicate: T->Bool): Vector<T>
		return SequenceExtension.filter(this, predicate);

	/** @see `banker.container.interfaces.Sequence` **/
	public inline function map<S>(callback: T->S): Vector<S>
		return SequenceExtension.map(this, callback);

	/** @see `banker.container.interfaces.Set` **/
	public function findFirst(predicate: (element: T) -> Bool, defaultValue: T): T
		return SetExtension.findFirst(this, predicate, defaultValue);

	/** @see `banker.container.interfaces.Set` **/
	public inline function remove(element: T): Bool
		return SetExtension.remove(this, element);

	/**
		@see `banker.container.interfaces.Set`
		@see `banker.container.buffer.top_aligned.SetExtension`
	**/
	public inline function removeAll(predicate: (element: T) -> Bool): Bool
		return SetExtension.removeShiftAll(this, predicate);

	/** @see `banker.container.interfaces.Set` **/
	public inline function has(element: T): Bool
		return SetExtension.has(this, element);

	/** @see `banker.container.interfaces.Set` **/
	public inline function hasAny(predicate: (element: T) -> Bool): Bool
		return SetExtension.hasAny(this, predicate);

	/**
		Adds `element` to `this`. Duplicates are allowed.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.pushInternal()`
	**/
	override inline function pushInternal(index: Int, element: T): Void {
		vector[index] = element;
		nextFreeSlotIndex = index + 1;
	}

	/**
		Adds all elements in `vector` to `this`.
		Duplicates are allowed.

		@see `banker.container.buffer.top_aligned.TopAlignedBuffer.pushFromVectorInternal()`
	**/
	override inline function pushFromVectorInternal(index: Int, otherVector: VectorReference<T>, otherVectorLength: Int): Void {
		VectorTools.blit(otherVector, 0, this.vector, index, otherVectorLength);
		this.nextFreeSlotIndex = index + otherVectorLength;
	}
}
