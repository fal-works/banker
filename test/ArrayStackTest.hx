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


	static function clone() {
		describe("This raises an exception if assertion is enabled.");
		final stack = new ArrayStack<String>(5);
		stack.push("AAA");
		stack.push("BBB");
		stack.push("CCC");
		stack.pop();

		final cloned = stack.cloneAsStack();
		assert(stack.capacity == cloned.capacity);
		assert(stack.size == cloned.size);
		assert(stack.toString() == cloned.toString());

		println('source: ${stack.toString()}\ncloned: ${cloned.toString()}');
	}

	static final _clone = testCase(clone, Ok);

	static function cloneResized() {
		describe("This raises an exception if assertion is enabled.");
		final stack = new ArrayStack<String>(5);
		stack.push("AAA");
		stack.push("BBB");
		stack.push("CCC");

		final cloned = stack.cloneAsStack(2);
		println('source: ${stack.toString()}\ncloned: ${cloned.toString()}');

		assert(cloned.capacity == 2);
		assert(cloned.size == 2);
		assert(cloned.toString() == "AAA, BBB");
	}

	static final _cloneResized = testCase(cloneResized, Ok);

	public static final all = testCaseGroup([
		_push,
		_pop,
		_emptyError,
		_clone,
		_cloneResized
	]);
}
