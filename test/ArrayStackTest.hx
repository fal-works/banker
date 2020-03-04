package;

import banker.container.ArrayStack;

class ArrayStackTest {
	static function push() {
		describe("none");
		final stack = new ArrayStack<String>(5);
		stack.push("AAA");
		stack.push("BBB");
		assert(stack.toString() == "AAA, BBB");
	}

	static final _push = testCase(push, Ok);

	static function pop() {
		describe("none");
		final stack = new ArrayStack<String>(5);
		stack.push("AAA");
		stack.push("BBB");
		final popped = stack.pop();
		assert(popped == "BBB");
	}

	static final _pop = testCase(pop, Ok);

	static function emptyError() {
		describe("This raises an exception if assertion is enabled.");
		final stack = new ArrayStack<String>(5);
		stack.push("AAA");
		stack.pop();
		stack.pop();
	}

	static final _emptyError = testCase(emptyError, Fail);

	public static final all = testCaseGroup([
		_push,
		_pop,
		_emptyError
	]);
}
