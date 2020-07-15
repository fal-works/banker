package;

import sneaker.unit_test.TesterSettings;

#if macro
using StringTools;
#end

// dunno how to do tests!
class Main {
	static final basicTestCases = testCaseGroup([VectorTest.all]);

	static final testCases = testCaseGroup([
		TopAlignedBufferTest.all,
		ArrayStackTest.all,
		ArrayQueueTest.all,
		ArrayMapTest.all,
		ArraySetTest.all
	]);

	static final poolTestCases = ObjectPoolTest.all;

	static final watermarkTestCases = WatermarkTest.all;

	static final aosoaTestCases = pkg.AosoaTest.all;

	static final finiteTestCases = finite.FiniteKeysTest.all;

	static final linkTestCases = link.LinkedListTest.all;

	static final bytesTestCases = BytesTest.all;

	static function main() {
		println("\n");

		TesterSettings.hidePassedResults = true;
		TesterSettings.showCallStack = true;

		// test(basicTestCases);
		// test(testCases);
		// test(watermarkTestCases);
		// test(poolTestCases);
		// test(aosoaTestCases);
		// test(finiteTestCases);
		// test(linkTestCases);
		test(bytesTestCases);
	}
}
