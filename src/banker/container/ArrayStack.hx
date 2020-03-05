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
	public inline function pushFromVector(otherVector: VectorReference<T>): Void
		StackExtension.pushFromVector(this, otherVector);

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override function removeAtInternal(
		vector: WritableVector<T>,
		currentSize: Int,
		index: Int
	): T {
		return InternalExtension.removeShiftAt(this, vector, currentSize, index);
	}

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function pushInternal(index: Int, element: T): Void
		InternalExtension.pushDuplicatesAllowed(this, index, element);

	/**
		@see `banker.container.buffer.top_aligned.TopAlignedBuffer`
		@see `banker.container.buffer.top_aligned.InternalExtension`
	**/
	override inline function pushFromVectorInternal(
		index: Int,
		otherVector: VectorReference<T>,
		otherVectorLength: Int
	): Void {
		InternalExtension.pushFromVectorDuplicatesAllowed(
			this,
			index,
			otherVector,
			otherVectorLength
		);
	}
}
