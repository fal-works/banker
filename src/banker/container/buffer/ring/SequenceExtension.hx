package banker.container.buffer.ring;

class SequenceExtension {
	/** @see `banker.container.interfaces.Sequence` **/
	public static inline function forEach<T>(
		_this: RingBuffer<T>,
		callback: T->Void
	): Void {
		final size = _this.size;
		final headIndex = _this.headIndex;
		final tailIndex = _this.tailIndex;
		final vector = _this.vector;
		final vectorLength = vector.length;

		if (headIndex + size <= vectorLength) {
			vector.ref.forEachIn(callback, headIndex, headIndex + size);
		} else {
			vector.ref.forEachIn(callback, headIndex, vectorLength);
			vector.ref.forEachIn(callback, 0, tailIndex);
		}
	}

	/** @see `banker.container.interfaces.Sequence` **/
	public static inline function filter<T>(
		_this: RingBuffer<T>,
		predicate: T->Bool
	): Vector<T> {
		final size = _this.size;
		final headIndex = _this.headIndex;
		final tailIndex = _this.tailIndex;
		final vector = _this.vector;
		final vectorLength = vector.length;

		return if (headIndex + size <= vectorLength) {
			vector.ref.filterIn(predicate, headIndex, headIndex + size);
		} else {
			final buffer: Array<T> = [];
			var i: Int;

			i = headIndex;
			while (i < vectorLength) {
				final item = vector[i];
				if (predicate(item)) buffer.push(item);
				++i;
			}

			i = 0;
			while (i < tailIndex) {
				final item = vector[i];
				if (predicate(item)) buffer.push(item);
				++i;
			}

			Vector.fromArrayCopy(buffer);
		}
	}

	/** @see `banker.container.interfaces.Sequence` **/
	@:access(banker.vector.WritableVector)
	public static inline function map<T, S>(
		_this: RingBuffer<T>,
		callback: T->S
	): Vector<S> {
		final size = _this.size;
		final headIndex = _this.headIndex;
		final tailIndex = _this.tailIndex;
		final vector = _this.vector;
		final vectorLength = vector.length;

		return if (headIndex + size <= vectorLength) {
			vector.ref.mapIn(callback, headIndex, headIndex + size);
		} else {
			final newVector = new WritableVector<S>(vectorLength);
			var sourceIndex: Int;
			var destinationIndex = 0;

			sourceIndex = headIndex;
			while (sourceIndex < vectorLength) {
				final item = vector[sourceIndex];
				newVector[destinationIndex] = callback(item);
				++sourceIndex;
				++destinationIndex;
			}

			sourceIndex = 0;
			while (sourceIndex < tailIndex) {
				final item = vector[sourceIndex];
				newVector[destinationIndex] = callback(item);
				++sourceIndex;
				++destinationIndex;
			}

			newVector.nonWritable();
		}
	}
}
