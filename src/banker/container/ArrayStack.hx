package banker.container;

// NOTE: Automatic static extension does not seem to work on generic classes
import banker.container.buffer.top_aligned.*;

/**
	Array-based stack.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayStack<T> extends TopAlignedOrderedBuffer<T> implements Stack<T> {
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
	public inline function pushFromVector(otherVector: VectorReference<T>): Void
		StackExtension.pushFromVector(this, otherVector);

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
