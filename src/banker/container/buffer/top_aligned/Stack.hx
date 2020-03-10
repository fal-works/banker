package banker.container.buffer.top_aligned;

#if !banker_generic_disable
@:generic
#end
class Stack<T>
	extends TopAlignedBuffer<T>
	implements banker.container.interfaces.Stack<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Stack` **/
	public inline function push(value: T): Void {
		final index = this.nextFreeSlotIndex;
		assert(index < this.capacity, this.tag, "The list is full.");

		this.pushInternal(index, value);
	}

	/** @see `banker.container.interfaces.Stack` **/
	public inline function pop(): T {
		final index = this.nextFreeSlotIndex - 1;
		assert(index >= 0, this.tag, "The list is empty.");

		this.setSize(index);

		return this.vector[index];
	}

	/** @see `banker.container.interfaces.Stack` **/
	public inline function peek(): T {
		final index = this.nextFreeSlotIndex - 1;
		assert(index >= 0, this.tag, "The list is empty.");

		return this.vector[index];
	}

	/** @see `banker.container.interfaces.Stack` **/
	public inline function pushFromVector(
		otherVector: VectorReference<T>
	): Void {
		final index = this.nextFreeSlotIndex;
		final otherVectorLength = otherVector.length;
		assert(
			index + otherVectorLength <= this.capacity,
			this.tag,
			"Not enough space."
		);

		this.pushFromVectorInternal(index, otherVector, otherVectorLength);
	}
}
