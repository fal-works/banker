package banker.watermark;

import sneaker.log.*;

class WatermarkSettings {
	/**
		Log type used in `Watermark.printUsage()`.
		@see README of `sneaker` library.
	**/
	public static var logType = createLogType();

	/**
		Sets a log level for `Watermark.printUsage()`.
		@see README of `sneaker` library.
	**/
	public static function setLogLevel(level: Int) {
		logType = createLogType(level);
	}

	static function createLogType(logLevel = 0) {
		final type = new LogType("[WATERMARK]", logLevel);
		type.logFormat = LogFormats.prefixMessage;
		return type;
	}
}
