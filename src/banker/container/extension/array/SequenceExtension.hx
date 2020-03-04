package banker.container.extension.array;

class SequenceExtension {
	public static inline function forEach<T>(_this: ArrayBase<T>, callback: T -> Void): Void {
		_this.vector.ref.forEachIn(callback, 0, _this.size);
	}
}
