package banker.container.extension.array;

class CommonExtension {
	public static inline function toString<T>(_this: ArrayBase<T>): String {
		return _this.vector.ref.joinIn(0, _this.size, ", ");
	}
}
