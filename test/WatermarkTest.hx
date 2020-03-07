package;

using sneaker.tag.TaggedExtension;

import banker.watermark.Watermark;
import banker.container.ArrayStack;

class WatermarkTest {
	static function watermark() {
		describe("This prints watermark result (A: 50%, B: 75%) if `banker_watermark_enabled` is set.");

		final stackA1 = new ArrayStack<Int>(10).newTag("stack group A");
		for (i in 0...2) stackA1.push(i);

		final stackA2 = new ArrayStack<Int>(10).newTag("stack group A"); // same name
		for (i in 0...5) stackA2.push(i);

		final stackB1 = new ArrayStack<Int>(20).newTag("stack group B");
		for (i in 0...15) stackB1.push(i);

		for (_ in 0...3) stackA2.pop();

		Watermark.printData();
	}

	static final _watermark = testCase(watermark, Visual);

	public static final all = testCaseGroup([
		_watermark
	]);
}
