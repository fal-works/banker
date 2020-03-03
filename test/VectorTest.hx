package;

import banker.ds.vector.Vector;
import banker.ds.vector.WritableVector;

class VectorTest {
	static final create = testCase(() -> {
		describe("This prints an array with length 10.");
		final vector = new WritableVector<Int>(10);
		println(vector);
	}, Visual);

	static final fromArrayCopy = testCase(() -> {
		describe("This prints an array [1, 2, 3].");
		final array: Array<Int> = [
			1,
			2,
			3
		];
		final vector = Vector.fromArrayCopy(array);
		println(vector);
	}, Visual);

	static final createFilled = testCase(() -> {
		describe("This prints an array of 10 ones.");
		final vector = Vector.createFilled(10, 1);
		println(vector);
	}, Visual);

	static final sub = testCase(() -> {
		describe("This prints [1, 2].");
		final vector = Vector.fromArrayCopy([
			1,
			2,
			3
		]);
		final newVector = vector.ref.subVector(0, 2);
		println(newVector);
	}, Visual);

	static final slice = testCase(() -> {
		describe("This prints [1, 2].");
		final vector = Vector.fromArrayCopy([
			1,
			2,
			3
		]);
		final newVector = vector.ref.slice(0, 2);
		println(newVector);
	}, Visual);

	static final find = testCase(() -> {
		describe("This prints 1.");
		final vector = Vector.fromArrayCopy([
			1,
			2,
			3
		]);
		println(vector.ref.find(2));
	}, Visual);

	static final forEach = testCase(() -> {
		describe("This prints 1, 2 and 3.");
		final vector = Vector.fromArrayCopy([
			1,
			2,
			3
		]);
		vector.ref.forEach(n -> println(n));
	}, Visual);


	static final fill = testCase(() -> {
		describe("This prints [4, 4, 4].");
		final vector = WritableVector.fromArrayCopy([
			1,
			2,
			3
		]);
		vector.fill(4);
		println(vector);
	}, Visual);

	public static final all = testCaseGroup([
		create,
		fromArrayCopy,
		createFilled,
		sub,
		slice,
		find,
		forEach,
		fill
	]);
}
