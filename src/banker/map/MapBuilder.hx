package banker.map;

using banker.type_extension.MapExtension;

import haxe.ds.Map as StdMap;
import banker.map.buffer.top_aligned.TopAlignedBuffer;

class MapBuilder {
	/**
		@param capacity Max number of key-value pairs that can be contained.
		if negative, the number of `map` keys is used.
		@return New `ArrayMap` instance created from `map`.
	**/
	public static function arrayMapFromStandardMap<K, V>(
		map: StdMap<K, V>,
		capacity: Int
	): ArrayMap<K, V> {
		final length = if (capacity >= 0) capacity else map.countKeys();
		final arrayMap = new ArrayMap<K, V>(length);
		blitFromStandardMapToBuffer(map, arrayMap);
		return arrayMap;
	}

	/**
		@param capacity Max number of key-value pairs that can be contained.
		if negative, the number of `map` keys is used.
		@return New `ArrayOrderedMap` instance created from `map`.
	**/
	public static function arrayOrderedMapFromStandardMap<K, V>(
		map: StdMap<K, V>,
		capacity: Int
	): ArrayOrderedMap<K, V> {
		final length = if (capacity >= 0) capacity else map.countKeys();
		final arrayMap = new ArrayOrderedMap<K, V>(length);
		blitFromStandardMapToBuffer(map, arrayMap);
		return arrayMap;
	}

	/**
		Overrites `buffer` with all key-value entries of `map`.
		This does not update watermark of `buffer`.
	**/
	static inline function blitFromStandardMapToBuffer<K, V>(
		map: StdMap<K, V>,
		buffer: TopAlignedBuffer<K, V>
	): Void {
		final keys = buffer.keyVector;
		final values = buffer.valueVector;
		var i = 0;
		for (key => value in map) {
			keys[i] = key;
			values[i] = value;
			++i;
		}
		buffer.nextFreeSlotIndex = i;
	}
}
