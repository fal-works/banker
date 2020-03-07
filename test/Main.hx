package;

import sneaker.unit_test.TesterSettings;

// @formatter:off

// dunno how to do tests!
class Main {
	static final testCases = testCaseGroup([
		NullableTest.all,
		VectorTest.all,
		TopAlignedBufferTest.all,
		ArrayStackTest.all,
		ArrayQueueTest.all,
		ArrayMapTest.all,
		ArraySetTest.all
	]);

	static final watermarkTestCases = WatermarkTest.all;

	static function main() {
		// TesterSettings.hidePassedResults = true;
		TesterSettings.showCallStack = true;

		test(testCases);
		test(watermarkTestCases);
	}
}
