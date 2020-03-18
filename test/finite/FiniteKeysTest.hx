package finite;

class FiniteKeysTest {
	static function basic() {
		describe("It's OK if it compiles and runs without error.");
		final set = new MySet();
		assert(set.A == false);
		set.A = true;
		assert(set.A == true);
	}
	static final _basic = testCase(basic, Ok);

	public static final all = testCaseGroup([
		_basic
	]);
}
