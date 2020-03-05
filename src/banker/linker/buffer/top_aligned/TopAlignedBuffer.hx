package banker.linker.buffer.top_aligned;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.linker)
class TopAlignedBuffer<K, V> extends Tagged {
	/**
		The number of element pairs that can be put to the collection.
	**/
	public var capacity(get, never): Int;

	/**
		Current number of element pairs.
	**/
	public var size(get, never): Int;

	/**
		The internal vector for keys.
	**/
	var keyVector: WritableVector<K>;

	/**
		The internal vector for values.
	**/
	var valueVector: WritableVector<V>;

	/**
		The index indicating the free slot for putting next element.
	**/
	var nextFreeSlotIndex: Int = 0;

	/**
		Clears `this` logically, i.e. the `size` is set to `0`
		but the references remain internally.
	**/
	public inline function clear(): Void
		this.nextFreeSlotIndex = 0;

	/**
		Clears `this` physically, i.e. the `size` is set to `0`
		and all references are explicitly nullified.
	**/
	public inline function clearPhysical(): Void {
		clear();
		keyVector.fill(cast null);
		valueVector.fill(cast null);
	}

	/**
		@return Current usage ratio between 0 and 1.
	**/
	public inline function getUsageRatio(): Float
		return size / capacity;

	/**
		@param capacity The number of elements that can be added to this.
	**/
	function new(capacity: Int) {
		assert(capacity >= 0);
		super();

		this.keyVector = new WritableVector<K>(capacity);
		this.valueVector = new WritableVector<V>(capacity);
	}

	/**
		@return A `String` representation of `this`.
	**/
	public function toString(): String {
		final size = this.size;
		return if (size == 0) {
			"{}";
		} else {
			final buffer = new StringBuf();
			final keys = this.keyVector;
			final values = this.valueVector;
			buffer.add("{ ");
			buffer.add(keys[0]);
			buffer.add(" => ");
			buffer.add(values[0]);
			for (i in 1...size) {
				buffer.add(", ");
				buffer.add(keys[i]);
				buffer.add(" => ");
				buffer.add(values[i]);
			}
			buffer.add(" }");

			buffer.toString();
		}
	}

	inline function get_capacity(): Int
		return keyVector.length;

	inline function get_size(): Int
		return nextFreeSlotIndex;
}
