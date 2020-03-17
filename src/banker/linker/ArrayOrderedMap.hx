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
@:ripper.verified
@:ripper.spirits(
	buffer.top_aligned.features.Map,
	buffer.top_aligned.features.Sequence,
	buffer.top_aligned.features.Set,
	buffer.top_aligned.constraints.Ordered
)
class ArrayOrderedMap<K, V>
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

	/** @see `banker.linker.interfaces.Convert` **/
	public inline function mapValues<W>(convertValue: V->W): ArrayOrderedMap<K, W> {
		final newMap = new ArrayOrderedMap<K, W>(this.capacity);
		ConvertExtension.copyWithMappedValues(this, newMap, convertValue);

		return newMap;
	}

	/** @see `sneaker.tag.TaggedExtension.setTag()` **/
	public function setTag(tag: Tag): ArrayOrderedMap<K, V>
		return TaggedExtension.setTag(this, tag);

	/** @see `sneaker.tag.TaggedExtension.newTag()` **/
	public function newTag(name: String, bits = 0xFFFFFFFF): ArrayOrderedMap<K, V>
		return TaggedExtension.newTag(this, name, bits);
}
