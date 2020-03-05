package banker.container;

// NOTE: Automatic static extension does not work on generic classes
import banker.container.buffer.top_aligned.*;

/**
	Array-based set.
	Suited for iteration or holding small number of entries.
	The order is not preserved.
**/
#if !banker_generic_disable
@:generic
#end
class ArraySet<T> extends TopAlignedUnorderedBuffer<T> implements Set<T> {
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `banker.container.interfaces.Set` **/
	public inline function add(element: T): Void
		StackExtension.push(this, element);

	/** @see `banker.container.interfaces.Set` **/
	public function findFirst(
		predicate: (element: T) -> Bool,
		defaultValue: T
	): T {@:nullSafety(Off) // HACK: Don't know why but this seems to be necessary
		return SetExtension.findFirst(this, predicate, defaultValue);
	}

	/** @see `banker.container.interfaces.Set` **/
	public inline function remove(element: T): Bool
		return SetExtension.remove(this, element);

	/**
		@see `banker.container.interfaces.Set`
		@see `banker.container.buffer.top_aligned.SetExtension`
	**/
	public inline function removeAll(predicate: (element: T) -> Bool): Bool
		return SetExtension.removeSwapAll(this, predicate);

	/** @see `banker.container.interfaces.Set` **/
	public inline function has(element: T): Bool
		return SetExtension.has(this, element);

	/** @see `banker.container.interfaces.Set` **/
	public inline function hasAny(predicate: (element: T) -> Bool): Bool
		return SetExtension.hasAny(this, predicate);

	/** @see `banker.container.interfaces.Sequence` **/
	public inline function forEach(callback: T->Void): Void
		SequenceExtension.forEach(this, callback);

	/** @see `banker.container.interfaces.Sequence` **/
	public inline function filter(predicate: T->Bool): Vector<T>
		return SequenceExtension.filter(this, predicate);

	/** @see `banker.container.interfaces.Sequence` **/
	public inline function map<S>(callback: T->S): Vector<S>
		return SequenceExtension.map(this, callback);
}
