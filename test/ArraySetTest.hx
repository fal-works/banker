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

	public static final all = testCaseGroup([
		_remove
	]);
}
