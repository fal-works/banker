package banker.linker;

import banker.linker.buffer.top_aligned.*;

/**
	Array-based map.
	Suited for iteration or holding small number of entries.

	Removing a single entry is done slower than `ArrayMap`,
	but instead the order is preserved.
**/
#if !banker_generic_disable
@:generic
#end
class OrderedArrayMap<K, V>
	extends TopAlignedMapBuffer<K, V>
	implements Set<K, V>
	implements Convert<K, V> {
	/**
		@param capacity Max number of key-value pairs `this` can contain.
	**/
	public function new(capacity: Int) {
		super(capacity);
	}

	/**
		@see `banker.linker.interfaces.Set`
		@see `banker.linker.buffer.top_aligned.SetExtension`
	**/
	public function removeAll(predicate: (key: K, value: V) -> Bool): Bool {
		return SetExtension.removeShiftAll(this, predicate);
	}

	/**
		@see `banker.linker.interfaces.Set`
		@see `banker.linker.buffer.top_aligned.SetExtension`
	**/
	public inline function removeApplyAll(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		return SetExtension.removeShiftApplyAll(this, predicate, callback);
	}

	/** @see `banker.linker.interfaces.Convert` **/
	public inline function mapValues<W>(convertValue: V->W): OrderedArrayMap<K, W> {
		final newMap = new OrderedArrayMap<K, W>(this.capacity);
		ConvertExtension.copyWithMappedValues(this, newMap, convertValue);

		return newMap;
	}

	/**
		Removes the key-value pair at `index` by shifting all entries at succeeding
		indices towards index zero (thus the order is preserved).
		O(n) complexity.

		@see `banker.linker.buffer.top_aligned.TopAlignedBuffer.removeAtInternal()`
	**/
	override function removeAtInternal(
		keyVector: WritableVector<K>,
		valueVector: WritableVector<V>,
		currentSize: Int,
		index: Int
	): Void {
		final nextSize = currentSize - 1;
		final movingRange = nextSize - index;
		keyVector.blitInternal(index + 1, index, movingRange);
		valueVector.blitInternal(index + 1, index, movingRange);
		this.nextFreeSlotIndex = nextSize;
	}
}
