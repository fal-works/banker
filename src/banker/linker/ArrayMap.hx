package banker.linker;

import banker.linker.buffer.top_aligned.*;

class ArrayGetSetExtension {
	public static function fromMap<K, V>(map: Map<K, V>, capacity: Int) {
		final arrayMap = new ArrayMap<K, V>(capacity);
		final keys = arrayMap.keyVector;
		final values = arrayMap.valueVector;
		var i = 0;
		for (key => value in map) {
			arrayMap.addKeyValue(keys, values, key, value, i);
			++i;
		}
		return arrayMap;
	}
}

#if !banker_generic_disable
@:generic
#end
class ArrayMap<K, V> extends TopAlignedBuffer<K, V> {
	/**
		@param capacity The number of elements that can be added to this.
	**/
	public function new(capacity: Int) {
		super(capacity);
	}

	/**
		Gets value for `key`. Be sure that `key` exists.
		@return The value that is mapped to `key`.
	**/
	public inline function get(key: K): V {
		return GetSetExtension.get(this, key);
	}

	/**
		Gets value for `key`.
		@return The value that is mapped to `key`. `null` if `key` does not exist.
	**/
	public inline function tryGet(key: K): Null<V> {
		return GetSetExtension.tryGet(this, key);
	}

	/**
		Maps `key` to `value`.
		If `key` already exists, the mapped value is overwritten.
		If not, adds a new key-value pair.
		@return  true if it is the first time that `key` is added.
	**/
	public function set(key: K, value: V): Bool {
		return GetSetExtension.set(this, key, value);
	}

	/**
		Maps `key` to `value` only if `key` does not exist.
		@return  true if it is the first time that `key` is added.
	**/
	public inline function setIfAbsent(key: K, value: V): Bool {
		return GetSetExtension.setIfAbsent(this, key, value);
	}

	/**
		Returns the value that is mapped to `key`.
		If not found, adds a new pair of `key` and `defaultValue`, and returns `defaultValue`.
	**/
	public inline function getOrAdd(key: K, defaultValue: V): V {
		return GetSetExtension.getOrAdd(this, key, defaultValue);
	}

	/**
		Returns the value that is mapped to `key`.
		If not found, creates new value with `valueFactory`,
		adds the new key-value pair and returns the created value.
	**/
	public inline function getOrAddWith(key: K, valueFactory: K->V): V {
		return GetSetExtension.getOrAddWith(this, key, valueFactory);
	}

	/**
		Checks if `this` has `key`.
		O(n) complexity.
		@return `true` if found.
	**/
	public inline function hasKey(key: K): Bool {
		return GetSetExtension.hasKey(this, key);
	}

	/**
		Runs `callback` for each key.
	**/
	public inline function forEachKey(callback: K->Void): Void {
		SequenceExtension.forEachKey(this, callback);
	}

	/**
		Runs `callback` for each value.
	**/
	public inline function forEachValue(callback: V->Void): Void {
		SequenceExtension.forEachValue(this, callback);
	}

	/**
		Runs `callback` for each key-value pair.
	**/
	public inline function forEach(callback: K->V->Void): Void {
		SequenceExtension.forEach(this, callback);
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
		SequenceExtension.forEachIndex(this, callback);
	}

	/**
		Removes the key-value pair at `index` by swapping elements with that at the last index
		(hence the order is not preserved).
		O(1) complexity.
	**/
	public inline function removeSwapAt(index: Int): Void {
		RemoveExtension.removeSwapAt(this, index);
	}

	/**
		Removes the first key-value pair that matches `key`.
		O(n) complexity.
		@return True if found and removed.
	**/
	public inline function remove(key: K): Bool {
		return RemoveExtension.remove(this, key);
	}

	/**
		Removes all key-value pairs that match `key`.
		@return  True if any found and removed.
	**/
	public function removeAll(key: K): Bool {
		return RemoveExtension.removeAll(this, key);
	}

	/**
		Removes the first key-value pair that matches `key` and returns the value.
		Be sure that `key` exists.
		O(n) complexity.
		@return The mapped value.
	**/
	public function removeGet(key: K): V {
		return RemoveExtension.removeGet(this, key);
	}

	/**
		Removes the first key-value pair that matches `key` and returns the value.
		O(n) complexity.
		@return The mapped value. Null if not found.
	**/
	public function tryRemoveGet(key: K): Null<V> {
		return RemoveExtension.tryRemoveGet(this, key);
	}

	/**
		Removes the first key-value pair that matches `key` and applies `callback` to the removing key-value pair.
		O(n) complexity.
	**/
	public function removeApply(key: K, callback: K->V->Void): Void {
		RemoveExtension.removeApply(this, key, callback);
	}

	public inline function keys(): Vector<K>
		return this.keyVector.ref.slice(0, this.size);

	public inline function values(): Vector<V>
		return this.valueVector.ref.slice(0, this.size);

	public inline function mapValues<W>(convertValue: V->W) {
		final newMap = new ArrayMap<K, W>(this.capacity);
		final keys = this.keyVector;
		final values = this.valueVector;
		final newKeys = newMap.keyVector;
		final newValues = newMap.valueVector;
		final len = this.size;
		var i = 0;
		while (i < len) {
			newMap.addKeyValue(newKeys, newValues, keys[i], convertValue(values[i]), i);
			++i;
		}

		return newMap;
	}
}
