package;

import sneaker.unit_test.TesterSettings;
import banker.*;

// dunno how to do tests!
class Main {
	static function main() {
		// TesterSettings.hidePassedResults = true;
		TesterSettings.showCallStack = true;

		test(testCaseGroup([
			// NullableTest.all,
			VectorTest.all
		]));
	}
}
