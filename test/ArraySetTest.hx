package;

import banker.container.ArraySet;
import banker.container.ArrayMultiSet;

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
		println("data: " + set.toString());
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
		println("data: " + set.toString());
	}

	static final _removeAll = testCase(removeAll, Ok);

	static function forEach() {
		describe();
		final set = new ArraySet<Int>(5);
		set.add(1);
		set.add(2);
		set.add(3);
		set.add(4);
		set.remove(2);
		set.add(5);
		set.add(2);
		var sum = 0;
		set.forEach(n -> sum += n);
		assert(sum == 15);
		println("data: " + set.toString());
	}

	static final _forEach = testCase(forEach, Ok);

	static function findFirst() {
		describe();
		final set = new ArraySet<Int>(5);
		set.add(1);
		set.add(2);
		set.add(3);
		set.add(4);
		final found: Int = set.findFirst(n -> n >= 3, -1);
		assert(found == 3);
		println("data: " + set.toString() + "  found: " + found);
	}

	static final _findFirst = testCase(findFirst, Ok);

	static function duplicate() {
		describe();
		final set = new ArraySet<Int>(5);
		set.add(1);
		set.add(2);
		set.add(1);
		set.add(3);
		assert(set.toString() == "1, 2, 3");
		println('data: ${set.toString()}');
	}

	static final _duplicate = testCase(duplicate, Ok);

	static function duplicateVector() {
		describe();
		final set = new ArraySet<Int>(8);
		set.add(2);
		set.add(4);
		set.addFromVector(banker.vector.Vector.fromArrayCopy([1, 2, 3, 4, 5, 6]));
		assert(set.toString() == "2, 4, 1, 3, 5, 6");
		println('data: ${set.toString()}');
	}

	static final _duplicateVector = testCase(duplicateVector, Ok);

	static function multiSet() {
		describe();
		final set = new ArrayMultiSet<Int>(8);
		set.add(2);
		set.add(2);
		set.add(4);
		set.addFromVector(banker.vector.Vector.fromArrayCopy([1, 2, 4, 6]));
		assert(set.toString() == "2, 2, 4, 1, 2, 4, 6");
		println('data: ${set.toString()}');
	}

	static final _multiSet = testCase(multiSet, Ok);

	static function count() {
		describe();
		final set = new ArraySet<Int>(8);
		set.add(1);
		set.add(2);
		set.add(3);
		set.add(4);
		final count = set.count(n -> n > 1 && n < 4);
		assert(count == 2);
		println('data: ${set.toString()}');
	}

	static final _count = testCase(count, Ok);

	public static final all = testCaseGroup([
		_remove,
		_removeAll,
		_forEach,
		_findFirst,
		_duplicate,
		_duplicateVector,
		_multiSet,
		_count
	]);
}
