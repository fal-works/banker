package;

using StringTools;

class Main {
	static function initialize() {
		sneaker.macro.MacroLogger.logFilter = (_, ?pos) -> {
			return if (pos == null) false; else if (pos.className.startsWith("ripper"))
				false; else true;
		}
	}
}
