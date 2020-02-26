package;

import banker.*;

// dunno how to do tests!
class Main {
	static final a = () -> {};

	static function main() {
		test(testCaseGroup([
			NullableTest.all,
			VectorTest.all
		]));
	}
}
