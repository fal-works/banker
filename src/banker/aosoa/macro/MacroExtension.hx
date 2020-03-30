package banker.aosoa.macro;

#if macro
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using banker.array.ArrayExtension;

import sneaker.macro.Values;
import sneaker.macro.MacroComparator;

class MacroExtension {
	/**
		@return `true` if `argument` is the special argument `i`.
	**/
	public static function argumentIsWriteIndex(argument: FunctionArg): Bool {
		if (argument.name != "i") return false;
		final complexType = argument.type;
		return complexType != null && complexType.toType().unify(Values.intType);
	}

	/**
		@return `true` if `argument` is the special argument `disuse`.
	**/
	public static function argumentIsDisuse(argument: FunctionArg): Bool {
		if (argument.name != "disuse") return false;
		final complexType = argument.type;
		return complexType != null && complexType.toType().unify(Values.boolType);
	}

	/**
		@return `true` if `type` is `null` or unifies `Void`.
	**/
	public static function isNullOrVoid(type: Null<ComplexType>): Bool {
		return type == null || MacroComparator.unifyComplex(
			type,
			Values.voidComplexType
		);
	}
}
#end
