package;

import banker.binary.Bytes;

class BytesTest {
	static function basic() {
		describe("none");

		final bytes = Bytes.alloc(12);
		final data = bytes.data;

		data.setInt32(0, 777);
		data.setFloat64(4, 3.14);

		final intValue = data.getInt32(0);
		assert(intValue == 777);

		final floatValue = data.getFloat64(4);
		assert(floatValue == 3.14);
	}

	static final _basic = testCase(basic, Ok);

	public static final all = testCaseGroup([
		_basic
	]);
}
