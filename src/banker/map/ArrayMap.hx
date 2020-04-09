package banker.map;

import banker.map.buffer.top_aligned.*;

/**
	Array-based map.
	Suited for iteration or holding small number of entries.

	Removing a single entry can be done faster than `ArrayOrderedMap`,
	but instead the order is not preserved.
**/
#if !banker_generic_disable
@:generic
#end
@:ripper_verified
@:ripper_spirits(
	buffer.top_aligned.features.Map,
	buffer.top_aligned.features.Sequence,
	buffer.top_aligned.features.Set,
	buffer.top_aligned.constraints.Unordered
)
class ArrayMap<K, V>
	extends TopAlignedBuffer<K, V>
	implements Map<K, V>
	implements Sequence<K, V>
	implements Set<K, V>
	implements Convert<K, V>
	implements ripper.Body {
	/**
		@param capacity Max number of key-value pairs `this` can contain.
	**/
	public function new(capacity: Int) {
		super(capacity);
	}

	/** @see `banker.map.interfaces.Convert` **/
	public inline function mapValues<W>(
		convertValue: (key: K, value: V) -> W
	): ArrayMap<K, W> {
		final newMap = new ArrayMap<K, W>(this.capacity);
		ConvertExtension.copyWithMappedValues(this, newMap, convertValue);

		return newMap;
	}

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayMap<K, V>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayMap<K, V>
		return TaggedExtension.newTag(this, name, bits);
}
