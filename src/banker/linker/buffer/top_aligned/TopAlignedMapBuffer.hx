package banker.linker.buffer.top_aligned;

/**
	Intermediate base class for top-aligned array-based maps that implements
	most of the methods required by the `Map` interface, but not all.

	The methods below needs to be implemented depending on the specification
	of the subclass.
	- mapValues
	- removeAll
	- removeApplyAll
	- removeAt (override)
**/
#if !banker_generic_disable
@:generic
#end
class TopAlignedMapBuffer<K, V>
	extends TopAlignedBuffer<K, V>
	implements Map<K, V>
	implements Sequence<K, V> {
	/**
		@param capacity Max number of key-value pairs `this` can contain.
	**/
	public function new(capacity: Int) {
		super(capacity);
	}

	/** @see `banker.linker.interfaces.Map` **/
	public inline function get(key: K): V
		return MapExtension.get(this, key);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function getOr(key: K, defaultValue: V): V
		return MapExtension.getOr(this, key, defaultValue);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function getOrElse(key: K, valueFactory: () -> V): V
		return MapExtension.getOrElse(this, key, valueFactory);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function tryGet(key: K): Null<V>
		return MapExtension.tryGet(this, key);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function set(key: K, value: V): Bool
		return MapExtension.set(this, key, value);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function setIfAbsent(key: K, value: V): Bool
		return MapExtension.setIfAbsent(this, key, value);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function getOrAdd(key: K, defaultValue: V): V
		return MapExtension.getOrAdd(this, key, defaultValue);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function getOrAddWith(key: K, valueFactory: K->V): V
		return MapExtension.getOrAddWith(this, key, valueFactory);

	/** @see `banker.linker.interfaces.Sequence` **/
	public inline function forEachKey(callback: (key: K) -> Void): Void
		SequenceExtension.forEachKey(this, callback);

	/** @see `banker.linker.interfaces.Sequence` **/
	public inline function forEachValue(callback: (value: V) -> Void): Void
		SequenceExtension.forEachValue(this, callback);

	/** @see `banker.linker.interfaces.Sequence` **/
	public inline function forEach(callback: (key: K, value: V) -> Void): Void
		SequenceExtension.forEach(this, callback);

	/** @see `banker.linker.interfaces.Sequence` **/
	public inline function forEachIndex(
		callback: (
			index: Int,
			keys: WritableVector<K>,
			values: WritableVector<V>
		) -> Void
	): Void {
		SequenceExtension.forEachIndex(this, callback);
	}

	/** @see `banker.linker.interfaces.Sequence` **/
	public inline function forFirst(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		return SequenceExtension.forFirst(this, predicate, callback);
	}

	/** @see `banker.linker.interfaces.Map` **/
	public inline function hasKey(key: K): Bool
		return MapExtension.hasKey(this, key);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function hasValue(value: V): Bool
		return MapExtension.hasValue(this, value);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function hasAny(predicate: (key: K, value: V) -> Bool): Bool
		return MapExtension.hasAny(this, predicate);

	/** @see `banker.linker.interfaces.Set` **/
	public inline function remove(key: K): Bool
		return SetExtension.remove(this, key);

	/** @see `banker.linker.interfaces.Set` **/
	public inline function removeGet(key: K): V
		return SetExtension.removeGet(this, key);

	/** @see `banker.linker.interfaces.Set` **/
	public inline function tryRemoveGet(key: K): Null<V>
		return SetExtension.tryRemoveGet(this, key);

	/** @see `banker.linker.interfaces.Set` **/
	public inline function removeApply(key: K, callback: (key: K, value: V) -> Void): Void
		SetExtension.removeApply(this, key, callback);

	/** @see `banker.linker.interfaces.Convert` **/
	public inline function exportKeys(): Vector<K>
		return ConvertExtension.exportKeys(this);

	/** @see `banker.linker.interfaces.Convert` **/
	public inline function exportValues(): Vector<V>
		return ConvertExtension.exportValues(this);
}
