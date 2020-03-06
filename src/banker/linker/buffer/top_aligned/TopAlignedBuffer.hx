package banker.linker.buffer.top_aligned;

import sneaker.exception.NotOverriddenException;
import banker.common.internal.LimitedCapacityBuffer;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.linker)
class TopAlignedBuffer<K, V> extends Tagged implements LimitedCapacityBuffer {
	/** @inheritdoc **/
	public var capacity(get, never): Int;

	/** @inheritdoc **/
	public var size(get, never): Int;

	/** The internal vector for keys. **/
	var keyVector: WritableVector<K>;

	/** The internal vector for values. **/
	var valueVector: WritableVector<V>;

	/** The index indicating the free slot for putting next element. **/
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

	/** @inheritdoc **/
	public inline function getUsageRatio(): Float
		return size / capacity;

	/** @inheritdoc **/
	public inline function toString(): String {
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

	/**
		@param capacity The number of elements that can be added to this.
	**/
	function new(capacity: Int) {
		assert(capacity >= 0);
		super();

		this.keyVector = new WritableVector<K>(capacity);
		this.valueVector = new WritableVector<V>(capacity);
	}

	inline function get_capacity(): Int
		return keyVector.length;

	inline function get_size(): Int
		return nextFreeSlotIndex;

	/**
		Internal method for adding `key` and `value` to `this` map.

		`keyVector`, `valueVector` and `currentSize` are likely already obtained from `this`
		before calling `addKeyValue()`, therefore this method requires them to be passed as arguments
		rather than obtaining them again in this method.

		@param keyVector `this.keyVector`
		@param valueVector `this.valueVector`
		@param currentSize Current size of `this`, used for determining the last index.
		@param key The key adding to `this`.
		@param value The value adding to `this`.
	**/
	inline function addKeyValue(
		keyVector: WritableVector<K>,
		valueVector: WritableVector<V>,
		currentSize: Int,
		key: K,
		value: V
	) {
		keyVector[currentSize] = key;
		valueVector[currentSize] = value;
		this.nextFreeSlotIndex = currentSize + 1;

		#if banker_watermark_enable
		updateWatermark(getUsageRatio()); // Currently does not work
		#end
	}

	/**
		Internal method for removing entry at `index` from `this`.

		`keyVector`, `valueVector` and `currentSize` are likely already obtained
		from `this` before calling `removeAtInternal()`, therefore this method
		requires them to be passed as arguments rather than obtaining them again
		in this method.

		This method must be overridden by the concrete subclass.

		@param keyVector `this.keyVector`
		@param valueVector `this.valueVector`
		@param currentSize Current size of `this`, used for determining the last index.
		@param index Index of the entry to be removed.
	**/
	function removeAtInternal(
		keyVector: WritableVector<K>,
		valueVector: WritableVector<V>,
		currentSize: Int,
		index: Int
	): Void {
		throw new NotOverriddenException();
	}
}
