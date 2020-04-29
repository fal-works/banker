package banker.map.buffer.top_aligned;

import sneaker.exception.NotOverriddenException;
import banker.common.LimitedCapacityBuffer;
import banker.watermark.Percentage;

#if !banker_generic_disable
@:generic
#end
@:allow(banker.map)
class TopAlignedBuffer<K, V> extends Tagged implements LimitedCapacityBuffer {
	/** @inheritdoc **/
	public var capacity(get, never): UInt;

	/** @inheritdoc **/
	public var size(get, never): UInt;

	/** The internal vector for keys. **/
	var keyVector: WritableVector<K>;

	/** The internal vector for values. **/
	var valueVector: WritableVector<V>;

	/** The index indicating the free slot for putting next element. **/
	var nextFreeSlotIndex: UInt = UInt.zero;

	/**
		Clears `this` logically, i.e. the `size` is set to `0`
		but the references remain internally.
	**/
	public inline function clear(): Void
		setSize(UInt.zero);

	/**
		Clears `this` physically, i.e. the `size` is set to `0`
		and all references are explicitly nullified.
	**/
	public inline function clearPhysical(): Void {
		clear();
		keyVector.fill(@:nullSafety(Off) cast null);
		valueVector.fill(@:nullSafety(Off) cast null);
	}

	/** @see `banker.map.interfaces.Convert` **/
	public inline function exportKeys(): Vector<K>
		return ConvertExtension.exportKeys(this);

	/** @see `banker.map.interfaces.Convert` **/
	public inline function exportValues(): Vector<V>
		return ConvertExtension.exportValues(this);

	/** @see `banker.map.interfaces.Convert` **/
	public inline function exportKeysWritable(): WritableVector<K>
		return ConvertExtension.exportKeysWritable(this);

	/** @see `banker.map.interfaces.Convert` **/
	public inline function exportValuesWritable(): WritableVector<V>
		return ConvertExtension.exportValuesWritable(this);

	/** @see banker.map.buffer.top_aligned.ConvertExtension **/
	public inline function cloneAsMap(newCapacity = MaybeUInt.none): ArrayMap<K, V>
		return ConvertExtension.cloneAsMap(this, newCapacity);

	/** @see banker.map.buffer.top_aligned.ConvertExtension **/
	public inline function cloneAsOrderedMap(
		newCapacity = MaybeUInt.none
	): ArrayOrderedMap<K, V>
		return ConvertExtension.cloneAsOrderedMap(this, newCapacity);

	/** @inheritdoc **/
	public inline function getUsageRatio(): Percentage
		return size / capacity;

	/** @inheritdoc **/
	public inline function toString(): String {
		final size = this.size;
		return if (size.isZero()) {
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
	function new(capacity: UInt) {
		super();

		this.keyVector = new WritableVector<K>(capacity);
		this.valueVector = new WritableVector<V>(capacity);
	}

	inline function get_capacity(): Int
		return keyVector.length;

	inline function get_size(): Int
		return nextFreeSlotIndex;

	/**
		Internal method for setting the current size of `this`.

		This also calls `setWatermark()` if watermark mode is enabled.
		Set `this.nextFreeSlotIndex` directly for avoiding this.
	**/
	inline function setSize(index: UInt): Int {
		this.nextFreeSlotIndex = index;
		#if banker_watermark_enable
		this.setWatermark(index / this.capacity);
		#end
		return index;
	}

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
		currentSize: UInt,
		key: K,
		value: V
	) {
		keyVector[currentSize] = key;
		valueVector[currentSize] = value;
		setSize(currentSize.plusOne());
	}

	/**
		Overwrites `this` by copying entries from `other`.
		Overflowing data is truncated.

		Should only be used for cloning instance as
		this does not check uniqueness of entries.
	**/
	inline function blitAllFrom(other: TopAlignedBuffer<K, V>): Void {
		final length = UInts.min(this.capacity, other.size);
		VectorTools.blitZero(other.keyVector, this.keyVector, length);
		VectorTools.blitZero(other.valueVector, this.valueVector, length);
		this.nextFreeSlotIndex = length;
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
		currentSize: UInt,
		index: UInt
	): Void {
		throw new NotOverriddenException();
	}

	/**
		Internal method for removing multiple entries.

		This method must be overridden by the concrete subclass
		according the specification e.g. whether to preserve order.

		@see `banker.map.interfaces.Set`
		@see `banker.map.buffer.top_aligned.InternalExtension`
	**/
	function removeAllInternal(predicate: (key: K, value: V) -> Bool): Bool {
		throw new NotOverriddenException();
	}

	/**
		Internal method for removing multiple entries
		and applying a callback function to them.

		This method must be overridden by the concrete subclass
		according the specification e.g. whether to preserve order.

		@see `banker.map.interfaces.Set`
		@see `banker.map.buffer.top_aligned.InternalExtension`
	**/
	function removeApplyAllInternal(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		throw new NotOverriddenException();
	}
}
