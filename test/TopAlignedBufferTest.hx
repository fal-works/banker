package;

import banker.container.ArrayStack;

@:access(banker.container.buffer.top_aligned.TopAlignedBuffer)
class TopAlignedBufferTest {
	static function clear() {
		describe();
		final stack = new ArrayStack<String>(2);
		stack.push("AAA");
		stack.clear();

		assert(stack.toString() == "");
		final s = stack.vector.ref.join(",");
		assert(s == "AAA,null");
	}

	static final _clear = testCase(clear, Ok);

	static function clearPhysicalInt() {
		describe();
		final stack = new ArrayStack<Int>(2);
		stack.push(1);
		stack.clearPhysical();

		assert(stack.toString() == "");
		final s = stack.vector.ref.join(",");
		assert(s == #if hl "0,0" #else "null,null" #end);
	}

	static final _clearPhysicalInt = testCase(clearPhysicalInt, Ok);

	static function clearPhysicalString() {
		describe();
		final stack = new ArrayStack<String>(2);
		stack.push("AAA");
		stack.clearPhysical();

		assert(stack.toString() == "");
		final s = stack.vector.ref.join(",");
		assert(s == "null,null");
	}

	static final _clearPhysicalString = testCase(clearPhysicalString, Ok);

	public static final all = testCaseGroup([
		_clear,
		_clearPhysicalInt,
		_clearPhysicalString
	]);
}
