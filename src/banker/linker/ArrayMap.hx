package banker.linker;

import banker.linker.buffer.top_aligned.*;

/**
	Array-based map.
	Suited for iteration or holding small number of entries.

	Removing a single entry can be done faster than `OrderedArrayMap`,
	but instead the order is not preserved.
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

	/**
		@see `banker.linker.interfaces.Remove`
		@see `banker.linker.buffer.top_aligned.RemoveExtension`
	**/
	public inline function removeAll(predicate: (key: K, value: V) -> Bool): Bool {
		return RemoveExtension.removeSwapAll(this, predicate);
	}

	/**
		@see `banker.linker.interfaces.Remove`
		@see `banker.linker.buffer.top_aligned.RemoveExtension`
	**/
	public inline function removeApplyAll(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		return RemoveExtension.removeSwapApplyAll(this, predicate, callback);
	}

	/** @see `banker.linker.interfaces.Convert` **/
	public inline function mapValues<W>(convertValue: V->W): ArrayMap<K, W> {
		final newMap = new ArrayMap<K, W>(this.capacity);
		ConvertExtension.copyWithMappedValues(this, newMap, convertValue);

		return newMap;
	}

	/**
		Removes the key-value pair at `index` by overwriting it with that at the last index
		(thus the order is not preserved).
		O(1) complexity.

		@see `banker.linker.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
	**/
	override function removeAtInternal(
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
