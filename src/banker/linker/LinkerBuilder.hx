package banker.linker;

class LinkerBuilder {
	/**
		@param capacity Max number of key-value pairs that can be contained.
		@return New `ArrayMap` instance created from `map`.
	**/
	public static function arrayMapFromStandardMap<K, V>(
		map: haxe.ds.Map<K, V>,
		capacity: Int
	) {
		final arrayMap = new ArrayMap<K, V>(capacity);
		final keys = arrayMap.keyVector;
		final values = arrayMap.valueVector;
		var i = 0;
		for (key => value in map) {
			keys[i] = key;
			values[i] = value;
			++i;
		}
		arrayMap.nextFreeSlotIndex = i;
		return arrayMap;
	}

	/**
		@param capacity Max number of key-value pairs that can be contained.
		@return New `ArrayOrderedMap` instance created from `map`.
	**/
	public static function orderedArrayMapFromStandardMap<K, V>(
		map: haxe.ds.Map<K, V>,
		capacity: Int
	) {
		final arrayMap = new ArrayOrderedMap<K, V>(capacity);
		final keys = arrayMap.keyVector;
		final values = arrayMap.valueVector;
		var i = 0;
		for (key => value in map) {
			keys[i] = key;
			values[i] = value;
			++i;
		}
		arrayMap.nextFreeSlotIndex = i;
		return arrayMap;
	}
}
