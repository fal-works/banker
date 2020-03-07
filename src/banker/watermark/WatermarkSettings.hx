package banker.watermark;

import sneaker.log.*;

class WatermarkSettings {
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

	static function createDefaultLogType(logLevel = 0) {
		final type = new LogType("[WATERMARK]", logLevel);
		type.logFormat = LogFormats.prefixMessage;
		return type;
	}
}
