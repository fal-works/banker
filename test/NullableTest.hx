package;

using banker.type_extension.NullableExtension;

@:nullSafety(Strict)
class NullableTest {
	public static final isNull = testCase(() -> {
		describe("This has no effect because the assertion succeeds.");
		final nullable: Null<Any> = null;
		assert(nullable.isNull());
	}, Ok);
	public static final exists = testCase(() -> {
		describe("This has no effect because the assertion succeeds.");
		final nullable: Null<Any> = "AAA";
		assert(nullable.exists());
	}, Ok);
	public static final all = testCaseGroup([
		isNull,
		exists
	]);
}
