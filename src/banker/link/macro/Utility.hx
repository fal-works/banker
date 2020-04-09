package banker.link.macro;

#if macro
import haxe.macro.Expr;

class Utility {
	public static function createDefaultConstructor(): Field {
		final dummyClass = macro class Dummy {
			public function new() {}
		};
		return dummyClass.fields[0];
	}
}
#end
