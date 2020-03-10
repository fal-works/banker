package;

import banker.watermark.Watermark;
import banker.watermark.WatermarkSettings;
import banker.container.ArrayStack;


class WatermarkTest {
	static function watermark() {
		describe("This prints watermark result (A: 50%, B: 75%) if `banker_watermark_enabled` is set.");

		Watermark.reset();

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

	static function exclude() {
		describe("This prints result if `banker_watermark_enabled` is set, but only for stack 2.");

		Watermark.reset();

		final bitMask = 0x00001111;
		WatermarkSettings.excludeTagBits = (bits: Int) -> bits & bitMask > 0;
		WatermarkSettings.usageDataMapBits = bitMask;

		final stack1 = new ArrayStack<Int>(10).newTag("stack 1", 0x00000101);
		for (i in 0...3) stack1.push(i);

		final stack2 = new ArrayStack<Int>(10).newTag("stack 2", 0x11110000);
		for (i in 0...5) stack2.push(i);

		Watermark.printData();
	}

	static final _exclude = testCase(exclude, Visual);


	public static final all = testCaseGroup([
		_watermark,
		_exclude
	]);
}
