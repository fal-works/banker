package;

import banker.linker.ArrayMap;
import banker.linker.ArrayOrderedMap;

class ArrayMapTest {
	static function getSet() {
		describe();
		final map = new ArrayMap<String, String>(5);
		map.set("keyA", "valueA");
		map.set("keyB", "valueB");

		assert(map.get("keyA") == "valueA");
		println("result: " + map.toString());
	}

	static final _getSet = testCase(getSet, Ok);

	static function setOverwrite() {
		describe();
		final map = new ArrayMap<String, String>(5);
		map.set("keyA", "valueA");
		map.set("keyB", "valueB");
		map.set("keyA", "valueA_overwritten");

		assert(map.get("keyA") == "valueA_overwritten");
		assert(map.toString() == "{ keyA => valueA_overwritten, keyB => valueB }");
		println("result: " + map.toString());
	}

	static final _setOverwrite = testCase(setOverwrite, Ok);

	static function remove() {
		describe();
		final map = new ArrayMap<String, String>(5);
		map.set("keyA", "valueA");
		map.set("keyB", "valueB");
		map.set("keyC", "valueC");
		map.set("keyD", "valueD");
		map.remove("keyA");
		final valueC = map.removeGet("keyC");

		assert(valueC == "valueC");
		assert(map.toString() == "{ keyD => valueD, keyB => valueB }");
		println("result: " + map.toString());
	}

	static final _remove = testCase(remove, Ok);

	static function removeOrdered() {
		describe();
		final map = new ArrayOrderedMap<String, String>(5);
		map.set("keyA", "valueA");
		map.set("keyB", "valueB");
		map.set("keyC", "valueC");
		map.set("keyD", "valueD");
		map.remove("keyA");
		final valueC = map.removeGet("keyC");

		assert(valueC == "valueC");
		assert(map.toString() == "{ keyB => valueB, keyD => valueD }");
		println("result: " + map.toString());
	}

	static final _removeOrdered = testCase(removeOrdered, Ok);

	static function getOrAdd() {
		describe();
		final map = new ArrayMap<String, String>(5);
		map.set("keyA", "valueA");
		final valueA = map.getOrAdd("keyA", "valueA2");
		final valueB = map.getOrAdd("keyB", "valueB");

		assert(valueA == "valueA");
		assert(valueB == "valueB");
		assert(map.toString() == "{ keyA => valueA, keyB => valueB }");
		println("result: " + map.toString());
	}

	static final _getOrAdd = testCase(getOrAdd, Ok);

	static function setIfAbsent() {
		describe();
		final map = new ArrayMap<String, String>(5);
		map.set("keyA", "valueA");
		map.setIfAbsent("keyA", "valueA2");
		map.setIfAbsent("keyB", "valueB");

		assert(map.get("keyA") == "valueA");
		assert(map.get("keyB") == "valueB");
		assert(map.toString() == "{ keyA => valueA, keyB => valueB }");
		println("result: " + map.toString());
	}

	static final _setIfAbsent = testCase(setIfAbsent, Ok);

	static function getSetInt() {
		describe();
		final map = new ArrayMap<Int, Int>(5);
		map.set(0, 10);
		map.set(1, 11);

		assert(map.get(0) == 10);
		println("result: " + map.toString());
	}

	static final _getSetInt = testCase(getSetInt, Ok);

	static function forEach() {
		describe();
		final map = new ArrayMap<Int, Int>(5);
		map.set(0, 10);
		map.set(1, 11);

		var keySum = 0;
		var valueSum = 0;
		map.forEachKey(key -> keySum += key);
		map.forEachValue(value -> valueSum += value);
		map.forEach((key, value) -> {
			keySum += key;
			valueSum += value;
		});

		assert(keySum == 2);
		assert(valueSum == 42);
		println("result: " + map.toString());
	}

	static final _forEach = testCase(forEach, Ok);

	static function removeAll() {
		describe();
		final map = new ArrayMap<Int, Int>(5);
		map.set(1, 10);
		map.set(2, 20);
		map.set(3, 30);
		map.set(4, 40);
		map.set(5, 50);

		map.removeAll((key, value) -> key == 4 || value < 15 || key == 3);
		assert(map.toString() == "{ 5 => 50, 2 => 20 }");

		println("result: " + map.toString());
	}

	static final _removeAll = testCase(removeAll, Ok);

	static function removeAllOrdered() {
		describe();
		final map = new ArrayOrderedMap<Int, Int>(5);
		map.set(1, 10);
		map.set(2, 20);
		map.set(3, 30);
		map.set(4, 40);
		map.set(5, 50);

		map.removeAll((key, value) -> key == 4 || value < 15 || key == 3);
		assert(map.toString() == "{ 2 => 20, 5 => 50 }");

		println("result: " + map.toString());
	}

	static final _removeAllOrdered = testCase(removeAllOrdered, Ok);

	static function forFirst() {
		describe();
		final map = new ArrayMap<Int, Int>(5);
		map.set(0, 10);
		map.set(1, 11);
		map.set(2, 12);

		var found = 0;
		map.forFirst((key, value) -> key >= 1, (key, value) -> found = value);

		assert(found == 11);
		println("Data: " + map.toString());
	}

	static final _forFirst = testCase(forFirst, Ok);

	static function setIf() {
		describe();
		final map = new ArrayMap<Int, Int>(5);
		map.set(0, 10);
		map.set(1, 11);

		final newIsGreater = function(
				key: Int,
				oldValue: Int,
				newValue: Int
		) return oldValue < newValue;

		map.setIf(0, 1000, newIsGreater);
		map.setIf(1, -1000, newIsGreater);
		assert(map.get(0) == 1000); // changed
		assert(map.get(1) == 11); // unchanged
		assert(map.toString() == "{ 0 => 1000, 1 => 11 }");

		println("Data: " + map.toString());
	}

	static final _setIf = testCase(setIf, Ok);

	static function clone() {
		describe();
		final map = new ArrayMap<Int, Int>(5);
		map.set(0, 10);
		map.set(1, 11);
		map.set(2, 12);

		final cloned = map.cloneAsMap();
		assert(map.capacity == cloned.capacity);
		assert(map.size == cloned.size);
		assert(map.toString() == cloned.toString());

		final cloned2 = map.cloneAsMap(2);
		assert(cloned2.capacity == 2);
		assert(cloned2.size == 2);
		assert(cloned2.toString() == "{ 0 => 10, 1 => 11 }");

		println('src:      ${map.toString()}');
		println('cloned:   ${cloned.toString()}');
		println('cloned 2: ${cloned2.toString()}');
	}

	static final _clone = testCase(clone, Ok);

	public static final all = testCaseGroup([
		_getSet,
		_setOverwrite,
		_remove,
		_removeOrdered,
		_getOrAdd,
		_setIfAbsent,
		_getSetInt,
		_forEach,
		_removeAll,
		_removeAllOrdered,
		_forFirst,
		_setIf,
		_clone
	]);
}
