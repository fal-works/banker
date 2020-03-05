package banker.linker;

import banker.linker.buffer.top_aligned.*;

/**
	Array-based map.
	Suited for iteration or holding small number of entries.
	- O(n) complexity for `get()`.
	- O(1) complexity for removing a single entry, but instead the order is not preserved.
**/
#if !banker_generic_disable
@:generic
#end
class ArrayMap<K, V> extends TopAlignedMapBuffer<K, V> implements Map<K, V> {
	/**
		@param capacity Max number of key-value pairs `this` can contain.
	**/
	public function new(capacity: Int) {
		super(capacity);
	}

	/** @see `banker.linker.buffer.top_aligned.RemoveExtension` **/
	public function removeAll(key: K): Bool {
		return RemoveExtension.removeSwapAll(this, key);
	}

	/** @see `banker.linker.buffer.top_aligned.ConvertExtension` **/
	public inline function mapValues<W>(convertValue: V->W): ArrayMap<K, W> {
		final newMap = new ArrayMap<K, W>(this.capacity);
		ConvertExtension.copyWithMappedValues(this, newMap, convertValue);

		return newMap;
	}

	/**
		Removes the key-value pair at `index` by overwriting it with that at the last index
		(thus the order is not preserved).
		O(1) complexity.

		@see `banker.linker.buffer.top_aligned.TopAlignedBuffer.removeAt()`
	**/
	override function removeAt(
		keyVector: WritableVector<K>,
		valueVector: WritableVector<V>,
		currentSize: Int,
		index: Int
	): Void {
		final lastIndex = currentSize - 1;
		keyVector[index] = keyVector[lastIndex];
		valueVector[index] = valueVector[lastIndex];
		this.nextFreeSlotIndex = lastIndex;
	}
}
