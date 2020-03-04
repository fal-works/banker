package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.buffer.top_aligned.*;

/**
	Array-based stack.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayList<T> extends TopAlignedBuffer<T> implements List<T> {
	public function new(capacity: Int)
		super(capacity);

	public inline function add(value: T): Void
		StackExtension.push(this, value);

	public inline function get(index: Int): T
		return IndexedExtension.get(this, index);

	public inline function set(index: Int, value: T): T
		return IndexedExtension.set(this, index, value);

	public inline function insertAt(index: Int, value: T): T
		return IndexedExtension.insertAt(this, index, value);

	public inline function removeAt(index: Int): T
		return IndexedExtension.removeAt(this, index);

	public inline function forEach(callback: T->Void): Void
		SequenceExtension.forEach(this, callback);

	public inline function filter(predicate: T->Bool): Vector<T>
		return SequenceExtension.filter(this, predicate);

	public inline function map<S>(callback: T->S): Vector<S>
		return SequenceExtension.map(this, callback);
}
