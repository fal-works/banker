package banker.container.buffer.top_aligned;

class CommonExtension {
	public static inline function toString<T>(_this: TopAlignedBuffer<T>): String {
		return _this.vector.ref.joinIn(0, _this.size, ", ");
	}
}
