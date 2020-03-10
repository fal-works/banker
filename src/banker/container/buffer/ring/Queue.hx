package banker.container.buffer.ring;

#if !banker_generic_disable
@:generic
#end
class Queue<T>
	extends RingBuffer<T>
	implements banker.container.interfaces.Queue<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Queue` **/
	public inline function enqueue(value: T): Void {
		final size = this.size;
		final capacity = this.capacity;
		assert(size < capacity, this.tag, "The queue is full.");

		final tailIndex = this.tailIndex;
		this.vector[tailIndex] = value;

		final nextTailIndex = tailIndex + 1;
		this.tailIndex = if (nextTailIndex < capacity) nextTailIndex else 0;

		this.setSize(size + 1);
	}

	/** @see `banker.container.interfaces.Queue` **/
	public inline function dequeue(): T {
		final size = this.size;
		assert(size > 0, this.tag, "The queue is empty.");

		final headIndex = this.headIndex;
		final nextHeadIndex = headIndex + 1;

		this.headIndex = if (nextHeadIndex < this.capacity) nextHeadIndex else 0;
		this.setSize(size - 1);

		return this.vector[headIndex];
	}
}
