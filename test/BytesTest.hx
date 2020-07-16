package;

import banker.binary.*;

class BytesTest {
	public static function basic() {
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

	public static function stack() {
		describe("none");

		final stack = ByteStack.alloc(16);

		stack.pushF32(0.25);
		stack.dup32();
		stack.pushI32(77);
		stack.swap32();

		var floatValue: Float;
		var intValue: Int;

		floatValue = stack.popF32();
		assert(floatValue == 0.25);
		intValue = stack.popI32();
		assert(intValue == 77);
		floatValue = stack.popF32();
		assert(floatValue == 0.25);
	}

	static final _basic = testCase(basic, Ok);
	static final _stack = testCase(stack, Ok);

	public static final all = testCaseGroup([_basic, _stack]);
}
