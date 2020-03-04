package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.extension.array.StackExtension;

/**
	Array-based stack.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayStack<T> extends ArrayBase<T> implements Stack<T> {
	public function new(capacity: Int)
		super(capacity);

	public inline function push(element: T): Void
		StackExtension.push(this, element);

	public inline function pop(): T
		return StackExtension.pop(this);

	public inline function peek(): T
		return StackExtension.peek(this);

	public inline function toString(): String
		return StackExtension.toString(this);
}
