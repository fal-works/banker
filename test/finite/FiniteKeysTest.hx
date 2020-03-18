package finite;

class FiniteKeysTest {
	static function set() {
		describe("It's OK if it compiles and runs without error.");
		final set = new MySet();
		assert(set.A == false);
		set.A = true;
		assert(set.A == true);
	}

	static final _set = testCase(set, Ok);

	static function myMap() {
		describe("It's OK if it compiles and runs without error.");
		final myMap = new MySet.MyMap();
		assert(myMap.A == 0);
		myMap.A = 1;
		assert(myMap.A == 1);
	}

	static final _myMap = testCase(myMap, Ok);

	public static final all = testCaseGroup([_myMap]);
}
