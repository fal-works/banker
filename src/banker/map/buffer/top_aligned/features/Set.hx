package banker.map.buffer.top_aligned.features;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Set<K, V>
	extends TopAlignedBuffer<K, V>
	implements banker.map.interfaces.Set<K, V>
	implements ripper.Spirit {
	/** @see `banker.map.interfaces.Set` **/
	public inline function hasKey(key: K): Bool
		return SetExtension.hasKey(this, key);

	/** @see `banker.map.interfaces.Set` **/
	public inline function hasValue(value: V): Bool
		return SetExtension.hasValue(this, value);

	/** @see `banker.map.interfaces.Set` **/
	public inline function hasAny(predicate: (key: K, value: V) -> Bool): Bool
		return SetExtension.hasAny(this, predicate);

	/** @see `banker.map.interfaces.Set` **/
	public inline function remove(key: K): Bool
		return SetExtension.remove(this, key);

	/** @see `banker.map.interfaces.Set` **/
	public inline function removeGet(key: K): V
		return SetExtension.removeGet(this, key);

	/** @see `banker.map.interfaces.Set` **/
	public inline function tryRemoveGet(key: K): Null<V>
		return SetExtension.tryRemoveGet(this, key);

	/** @see `banker.map.interfaces.Set` **/
	public inline function removeApply(key: K, callback: (key: K, value: V) -> Void): Void
		SetExtension.removeApply(this, key, callback);

	/** @see `banker.map.interfaces.Set` **/
	public inline function removeAll(predicate: (key: K, value: V) -> Bool): Bool
		return SetExtension.removeAll(this, predicate);

	/** @see `banker.map.interfaces.Set` **/
	public inline function removeApplyAll(
		predicate: (key: K, value: V) -> Bool,
		callback: (key: K, value: V) -> Void
	): Bool {
		return SetExtension.removeApplyAll(this, predicate, callback);
	}
}
