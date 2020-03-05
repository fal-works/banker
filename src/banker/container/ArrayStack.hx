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
	/** @inheritdoc **/
	public function new(capacity: Int)
		super(capacity);

	/** @see `banker.container.interfaces.Stack` **/
	public inline function push(element: T): Void
		StackExtension.push(this, element);

	/** @see `banker.container.interfaces.Stack` **/
	public inline function pop(): T
		return StackExtension.pop(this);

	/** @see `banker.container.interfaces.Stack` **/
	public inline function peek(): T
		return StackExtension.peek(this);

	/** @see `banker.container.interfaces.Stack` **/
	public inline function pushFromVector(vector: VectorReference<T>): Void
		StackExtension.pushFromVector(this, vector);
}
