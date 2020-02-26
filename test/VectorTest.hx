package;

import banker.ds.Vector;
import banker.ds.VectorTools;

@:nullSafety(Strict)
class VectorTest {
	public static final create = testCase(() -> {
		describe("This prints an array with length 10.");
		final vector = new Vector<Int>(10);
		println(vector);
	}, Visual);
	public static final fromArrayCopy = testCase(() -> {
		describe("This prints an array [1, 2, 3].");
		final array: Array<Int> = [
			1,
			2,
			3
		];
		final vector = VectorTools.fromArrayCopy(array);
		println(vector);
	}, Visual);
	public static final createFilled = testCase(() -> {
		describe("This prints an array of 10 ones.");
		final vector = VectorTools.createFilled(10, 1);
		println(vector);
	}, Visual);
	// public static final dummy = testCaseGroup([]);
	public static final all = testCaseGroup([
		create,
		fromArrayCopy,
		createFilled
	]);
}
