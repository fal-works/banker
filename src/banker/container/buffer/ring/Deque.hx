package banker.container.buffer.ring;

#if !banker_generic_disable
@:generic
#end
class Deque<T>
	extends RingBuffer<T>
	implements banker.container.interfaces.Deque<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Deque` **/
	public inline function pushBack(value: T): Void
		QueueExtension.enqueue(this, value);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function popFront(): T
		return QueueExtension.dequeue(this);

	/** @see `banker.container.interfaces.Deque` **/
	public inline function pushFront(value: T): Void {
		final size = this.size;
		final capacity = this.capacity;
		assert(size < capacity, this.tag, "The queue is full.");

		final headIndex = this.headIndex;

		final nextHeadIndex = if (headIndex > 0) headIndex - 1 else capacity - 1;
		this.headIndex = nextHeadIndex;
		this.vector[nextHeadIndex] = value;

		this.setSize(size + 1);
	}

	/** @see `banker.container.interfaces.Deque` **/
	public inline function popBack(): T {
		final size = this.size;
		assert(size > 0, this.tag, "The queue is empty.");

		final tailIndex = this.tailIndex;
		final nextTailIndex = if (tailIndex > 0) tailIndex - 1 else this.capacity - 1;

		this.tailIndex = nextTailIndex;
		this.setSize(size - 1);

		return this.vector[nextTailIndex];
	}
}
