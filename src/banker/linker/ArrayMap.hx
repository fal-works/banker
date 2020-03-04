package banker.linker;

using banker.NullSafeUtility;

class ArrayMapExtension {
	public static function fromMap<K, V>(map: Map<K, V>, capacity: Int) {
		final arrayMap = new ArrayMap<K, V>(capacity);
		for (key => value in map) arrayMap.add(key, value);
		return arrayMap;
	}
}

#if !banker_generic_disable
@:generic
#end
class ArrayMap<K, V> extends Tagged {
	/**
		The number of element pairs that can be put to the collection.
	**/
	public var capacity(default, null): Int;

	/**
		Current number of element pairs.
	**/
	public var size(get, never): Int;

	inline function get_size(): Int
		return nextFreeSlotIndex;

	/**
		The internal vector for keys.
	**/
	var keyVector: WritableVector<K>;

	/**
		The internal vector for values.
	**/
	var valueVector: WritableVector<V>;

	/**
		The index indicating the next free slot for putting element by `add()`.
	**/
	var nextFreeSlotIndex: Int = 0;

	/**
		@return Current usage ratio between 0 and 1.
	**/
	public inline function getUsageRatio(): Float
		return size / capacity;

	/**
		@param capacity The number of elements that can be added to this.
	**/
	public function new(capacity: Int) {
		assert(capacity >= 0);
		super();

		this.capacity = capacity;

		this.keyVector = new WritableVector<K>(capacity);
		this.valueVector = new WritableVector<V>(capacity);
	}

	/**
		Gets value for `key`. Be sure that `key` exists.
		@return The value that is mapped to `key`.
	**/
	public inline function get(key: K): V {
		final index = keyVector.ref.findIndexIn(key, 0, size);
		assert(index >= 0, this.tag, "Not found.");
		return valueVector[index];
	}

	/**
		Gets value for `key`.
		@return The value that is mapped to `key`. `null` if `key` does not exist.
	**/
	public inline function tryGet(key: K): Null<V> {
		final index = keyVector.ref.findIndexIn(key, 0, size);
		return if (index >= 0) valueVector[index] else null;
	}

	/**
		Adds a new key-value pair. Duplicate keys are allowed.
	**/
	public inline function add(key: K, value: V): Void {
		assert(size < capacity, this.tag, "The map is full.");

		final index = this.nextFreeSlotIndex;
		keyVector[index] = key;
		valueVector[index] = value;
		nextFreeSlotIndex = index + 1;

		#if banker_watermark_enable
		updateWatermark(usage()); // Currently does not work
		#end
	}

	/**
		Maps `key` to `value`.
		If `key` already exists, the mapped value is overwritten.
		If not, adds a new key-value pair.
		@return  true if it is the first time that `key` is added.
	**/
	public function set(key: K, value: V): Bool {
		return if (this.keyVector.ref.hasIn(key, 0, size)) {
			false;
		} else {
			assert(size < capacity, this.tag, "The map is full.");

			add(key, value);
			true;
		}
	}

	/**
		Returns the value that is mapped to `key`.
		If not found, creates new value with `valueFactory`,
		adds the new key-value pair and returns the created value.
	**/
	public inline function getOrAdd(key: K, valueFactory: K->V): V {
		final index = this.keyVector.ref.findIndexIn(key, 0, size);

		return if (index >= 0) {
			valueVector[i];
		} else {
			final newValue = valueFactory(key);
			add(key, newValue);

			newValue;
		}
	}

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

	/**
		Runs `callback` for each key.
	**/
	public inline function forEachKey(callback: K->Void): Void {
		keyVector.ref.forEachIn(callback, 0, size);
	}

	/**
		Runs `callback` for each value.
	**/
	public inline function forEachValue(callback: V->Void): Void {
		valueVector.ref.forEachIn(callback, 0, size);
	}

	/**
		Runs `callback` for each key-value pair.
	**/
	public inline function forEach(callback: K->V->Void): Void {
		final keys = this.keyVector;
		final values = this.valueVector;
		final len = this.size;
		var i = 0;
		while (i < len) {
			callback(keys[i], values[i]);
			++i;
		}
	}

	/**
		Runs `callback` for each key-value pair.
	**/
	public inline function forEachIndex(
		callback: (
			index: Int,
			keys: WritableVector<K>,
			values: WritableVector<V>
		) -> Void
	): Void {
		final keys = this.keyVector;
		final values = this.valueVector;
		final len = this.size;
		var i = 0;
		while (i < len) {
			callback(i, keys, values);
			++i;
		}
	}

	/**
		Removes the key-value pair at `index` by swapping elements with that at the last index
		(hence the order is not preserved).
		O(1) complexity.
	**/
	public inline function removeSwapAt(index: Int): Void {
		final lastIndex = nextFreeSlotIndex - 1;
		keyVector[index] = keyVector[lastIndex];
		valueVector[index] = valueVector[lastIndex];
		this.nextFreeSlotIndex = lastIndex;
	}

	/**
		Removes the first key-value pair that matches `key`.
		O(n) complexity.
		@return True if found and removed.
	**/
	public inline function remove(key: K): Bool {
		var found = false;
		final keys = this.keyVector;
		final values = this.valueVector;
		var len = this.size;
		var i = 0;
		while (i < len) {
			if (keys[i] != key) {
				++i;
				continue;
			}

			--len;
			keys[i] = keys[len];
			values[i] = values[len];
			this.nextFreeSlotIndex = len;
			found = true;
			break;
		}

		return found;
	}

	/**
		Removes all key-value pairs that match `key`.
		@return  True if any found and removed.
	**/
	public function removeAll(key: K): Bool {
		var found = false;
		final keys = this.keyVector;
		final values = this.keyVector;
		var len = this.size;
		var i = 0;
		while (i < len) {
			if (keys[i] != key) {
				++i;
				continue;
			}

			--len;
			keys[i] = keys[len];
			values[i] = values[len];
			found = true;
		}

		this.nextFreeSlotIndex = len;

		return found;
	}

	/**
		Removes the first key-value pair that matches `key` and returns the value.
		Be sure that `key` exists.
		O(n) complexity.
		@return The mapped value.
	**/
	public function removeGet(key: K): V {
		final index = keyVector.ref.findIndexIn(key, 0, size);
		assert(index >= 0, this.tag, "Not found.");

		final value = valueVector[index];
		removeSwapAt(index);
		return value;
	}

	/**
		Removes the first key-value pair that matches `key` and returns the value.
		O(n) complexity.
		@return The mapped value. Null if not found.
	**/
	public function tryRemoveGet(key: K): Null<V> {
		final index = keyVector.ref.findIndexIn(key, 0, size);

		return if (index >= 0) {
			final value = valueVector[index];
			removeSwapAt(index);
			value;
		} else null;
	}

	/**
		Removes the first key-value pair that matches `key` and applies `callback` to the removing key-value pair.
		O(n) complexity.
	**/
	public function removeApply(key: K, callback: K->V->Void): Void {
		final keys = this.keyVector;
		final values = this.valueVector;
		final len = this.size;
		var i = 0;
		while (i < len) {
			if (keys[i] != key) {
				++i;
				continue;
			}

			callback(keys[i], values[i]);
			final lastIndex = this.nextFreeSlotIndex - 1;
			keys[i] = keys[lastIndex];
			values[i] = values[lastIndex];
			this.nextFreeSlotIndex = lastIndex;
			break;
		}
	}

	/**
		Checks if `this` has `key`.
		O(n) complexity.
		@return `true` if found.
	**/
	public inline function hasKey(key: K): Bool {
		return keyVector.ref.hasIn(key, 0, size);
	}

	/**
		@return A `String` representation of `this`.
	**/
	public function toString(): String {
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
}
