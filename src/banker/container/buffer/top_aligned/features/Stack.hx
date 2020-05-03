package banker.container.buffer.top_aligned.features;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Stack<T>
	extends TopAlignedBuffer<T>
	implements banker.container.interfaces.Stack<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Stack` **/
	public inline function push(value: T): Void
		StackExtension.push(this, value);

	/** @see `banker.container.interfaces.Stack` **/
	public inline function pop(): T
		return StackExtension.pop(this);

	/** @see `banker.container.interfaces.Stack` **/
	public inline function peek(): T
		return StackExtension.peek(this);

	/** @see `banker.container.interfaces.Stack` **/
	public inline function pushFromVector(otherVector: VectorReference<T>): Void
		StackExtension.pushFromVector(this, otherVector);

	/** @see `banker.container.interfaces.Stack` **/
	public inline function swap(): Void
		return StackExtension.swap(this);
}
