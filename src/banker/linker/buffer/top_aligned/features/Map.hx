package banker.linker.buffer.top_aligned.features;

#if !banker_generic_disable
@:generic
#end
class Map<K, V>
	extends TopAlignedBuffer<K, V>
	implements banker.linker.interfaces.Map<K, V>
	implements ripper.Spirit {
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
	public inline function setIf(
		key: K,
		newValue: V,
		predicate: (
			key: K,
			oldValue: V,
			newValue: V
		) -> Bool
	): Bool {
		return MapExtension.setIf(this, key, newValue, predicate);
	}

	/** @see `banker.linker.interfaces.Map` **/
	public inline function getOrAdd(key: K, defaultValue: V): V
		return MapExtension.getOrAdd(this, key, defaultValue);

	/** @see `banker.linker.interfaces.Map` **/
	public inline function getOrAddWith(key: K, valueFactory: K->V): V
		return MapExtension.getOrAddWith(this, key, valueFactory);
}
