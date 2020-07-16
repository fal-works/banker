package;

import banker.binary.Bytes;

class BytesTest {
	static function basic() {
		describe("none");

		final bytes = Bytes.alloc(12);
		final data = bytes.data;

		data.setI32(0, 777);
		data.setF64(4, 3.14);

		final intValue = data.getI32(0);
		assert(intValue == 777);

		final floatValue = data.getF64(4);
		assert(floatValue == 3.14);
	}

	static final _basic = testCase(basic, Ok);

	public static final all = testCaseGroup([
		_basic
	]);
}
