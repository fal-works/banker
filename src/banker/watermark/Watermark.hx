package banker.watermark;

/**
	Stores and prints watermark data.
**/
class Watermark {
	/**
		Data set storing maximum usage ratio of data collection objects
		for each tag name.

		At the program startup, a Null Object is set.
		The actual data is assigned if
		- The compiler flag `banker_watermark_enable` is set, and
		- The size of any data collection object changes.
	**/
	public static var data(default, null) = WatermarkData.createNull();

	/**
		Prints data about the maximum usage ratio of data collection objects
		since the program was started (or since the last call of `Watermark.reset()`).

		- The data is grouped by tag names.
		- The value is the size to capacity ratio in percentage.
		If any value is close to 100%, maybe you should reconsider the capacity
		for avoiding data overflow.
	**/
	public static inline function printData(): Void
		data.print();

	/**
		Clears all usage data.
		Settings in `WatermarkSettings` remain.
	**/
	public static inline function reset(): Void
		data.reset();
}
