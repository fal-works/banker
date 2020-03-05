package banker.container.buffer.top_aligned;

class SequenceExtension {
	public static inline function forEach<T>(
		_this: TopAlignedBuffer<T>,
		callback: T->Void
	): Void {
		_this.vector.ref.forEachIn(callback, 0, _this.size);
	}

	public static inline function filter<T>(
		_this: TopAlignedBuffer<T>,
		predicate: T->Bool
	): Vector<T> {
		return _this.vector.ref.filterIn(predicate, 0, _this.size);
	}

	public static inline function map<T, S>(
		_this: TopAlignedBuffer<T>,
		callback: T->S
	): Vector<S> {
		return _this.vector.ref.mapIn(callback, 0, _this.size);
	}
}
