package;

import banker.linker.ArrayMap;

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
		map.remove("keyA");
		final valueC = map.removeGet("keyC");

		assert(valueC == "valueC");
		assert(map.toString() == "{ keyB => valueB }");
		println("result: " + map.toString());
	}

	static final _remove = testCase(remove, Ok);

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

	public static final all = testCaseGroup([
		_getSet,
		_setOverwrite,
		_remove,
		_getOrAdd,
		_setIfAbsent,
		_getSetInt,
		_forEach
	]);
}
