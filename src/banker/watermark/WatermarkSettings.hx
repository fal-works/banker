package banker.watermark;

import sneaker.log.*;

class WatermarkSettings {
	/**
		Filtering function for excluding specific data collection objects
		from watermark data.
		At default, only the objects that have tags with zero bits set are excluded.

		Reassign any custom function for setting another condition
		(in that case, `WatermarkSettings.usageDataMapBits` may also need to be modified).
	**/
	public static var excludeTagBits = (bits: Int) -> bits == 0x00000000;

	/**
		The bits of a tag that is attached to the map for storing watermark data.
		Used for excluding itself from the data in combination with
		`WatermarkSettings.excludeTagBits()`.
	**/
	public static var usageDataMapBits(default, set) = 0x00000000;

	/**
		Log type used in `Watermark.printUsage()`.
		@see README of `sneaker` library.
	**/
	public static var logType = createDefaultLogType();

	/**
		Sets a log level for `Watermark.printUsage()`.
		@see README of `sneaker` library.
	**/
	public static function setLogLevel(level: Int) {
		final currentType = logType;
		final newType = createDefaultLogType(level);

		newType.prefix = currentType.prefix;
		newType.copyFormatsFrom(currentType);

		logType = newType;
	}

	static function set_usageDataMapBits(bits: Int): Int
		return Watermark.data.setUsageDataMapBits(bits);

	static function createDefaultLogType(logLevel = 0) {
		final type = new LogType("[WATERMARK]", logLevel);
		type.logFormat = LogFormats.prefixMessage;
		return type;
	}
}
