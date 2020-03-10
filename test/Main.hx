package;

import sneaker.unit_test.TesterSettings;

// dunno how to do tests!
class Main {
	static final basicTestCases = testCaseGroup([
		NullableTest.all,
		VectorTest.all
	]);

	static final testCases = testCaseGroup([
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

		test(basicTestCases);
		test(testCases);
		test(watermarkTestCases);
	}
}
