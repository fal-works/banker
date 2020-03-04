package banker.container;

// NOTE: Static extension does not seem to work on generic classes

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
		ArrayStackExtension.push(this, element);

	public inline function pop(): T
		return ArrayStackExtension.pop(this);

	public inline function toString(): String
		return ArrayStackExtension.toString(this);
}
