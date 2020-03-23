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

	static function getterSetter() {
		describe("It goes without error.");
		final myMap = new MySet.MyMap2();
		final getA = myMap.getter(A);
		assert(getA() == 1);
		final setB = myMap.setter(B);
		setB(3);
		assert(myMap.B == 3);
	}

	static final _getterSetter = testCase(getterSetter, Ok);

	static function forEach() {
		describe("It goes without error.");
		final myMap = new MySet.MyMap2();
		var sum = 0;
		myMap.forEach((key, value) -> sum += value);
		assert(sum == 5);
	}

	static final _forEach = testCase(forEach, Ok);

	static function interfaceTest() {
		describe("It's OK if it compiles.");
		final myMap: banker.finite.interfaces.FiniteKeysMap<finite.Abc, Int> = new MySet.MyMap2();
		final a = myMap.get(A);
		assert(a == 1);
	}

	static final _interfaceTest = testCase(interfaceTest, Ok);

	public static final all = testCaseGroup([
		_set,
		_myMap,
		_mapWithFactory,
		_getterSetter,
		_forEach,
		_interfaceTest
	]);
}
