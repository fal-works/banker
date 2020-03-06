package;

import sneaker.unit_test.TesterSettings;

// @formatter:off

// dunno how to do tests!
class Main {
	static function main() {
		// TesterSettings.hidePassedResults = true;
		TesterSettings.showCallStack = true;

		test(testCaseGroup([
			// NullableTest.all,
			// VectorTest.all,
			// TopAlignedBufferTest.all,
			// ArrayStackTest.all,
			// ArrayQueueTest.all,
			// ArrayMapTest.all,
			ArraySetTest.all
		]));
	}
}
