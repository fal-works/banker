package;

import banker.container.ArraySet;

class ArraySetTest {
	static function remove() {
		describe();
		final set = new ArraySet<String>(5);
		set.add("AAA");
		set.add("BBB");
		set.add("CCC");
		set.add("DDD");
		set.remove("BBB");
		assert(set.toString() == "AAA, DDD, CCC");
	}

	static final _remove = testCase(remove, Ok);

	static function removeAll() {
		describe();
		final set = new ArraySet<Int>(5);
		set.add(1);
		set.add(2);
		set.add(3);
		set.add(4);
		set.add(5);
		set.removeAll(n -> n == 2 || n == 4);
		assert(set.toString() == "1, 5, 3");
	}

	static final _removeAll = testCase(removeAll, Ok);

	public static final all = testCaseGroup([
		_remove,
		_removeAll
	]);
}
