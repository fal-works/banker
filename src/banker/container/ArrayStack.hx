package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.buffer.top_aligned.*;

/**
	Array-based stack.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayStack<T> extends TopAlignedBuffer<T> implements Stack<T> {
	public function new(capacity: Int)
		super(capacity);

	public inline function push(element: T): Void
		StackExtension.push(this, element);

	public inline function pop(): T
		return StackExtension.pop(this);

	public inline function peek(): T
		return StackExtension.peek(this);

	public inline function pushFromVector(vector: VectorReference<T>): Void
		StackExtension.pushFromVector(this, vector);
}
