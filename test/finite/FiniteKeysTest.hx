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

		final a = myMap.get(A);
		assert(a == 1);

		myMap.set(B, 2);
		assert(myMap.B == 2);
	}

	static final _myMap = testCase(myMap, Ok);

	static function mapWithFactory() {
		describe("It goes without error.");
		final myMap = new MySet.MyMap2();
		assert(myMap.A == 1);
		assert(myMap.B == 2);
		assert(myMap.C == 2);
	}

	static final _mapWithFactory = testCase(mapWithFactory, Ok);

	public static final all = testCaseGroup([_set, _myMap, _mapWithFactory]);
}
