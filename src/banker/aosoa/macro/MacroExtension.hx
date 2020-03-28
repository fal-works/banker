package banker.aosoa.macro;

#if macro
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using banker.array.ArrayExtension;

import sneaker.macro.ComplexTypes;
import sneaker.macro.MacroComparator;

class MacroExtension {
	/**
		@return `true` if `argument` is the special argument `i`.
	**/
	public static function argumentIsWriteIndex(argument: FunctionArg): Bool
		return argument.name == "i" && MacroComparator.unifyComplex(
			argument.type,
			ComplexTypes.intType
		);

	/**
		@return `true` if `argument` is the special argument `disuse`.
	**/
	public static function argumentIsDisuse(argument: FunctionArg): Bool
		return argument.name == "disuse" && argument.type != null && MacroComparator.unifyComplex(
			argument.type,
			ComplexTypes.boolType
		);

	/**
		@return `true` if `type` is `null` or unifies `Void`.
	**/
	public static function isNullOrVoid(type: Null<ComplexType>): Bool {
		return type == null || MacroComparator.unifyComplex(
			type,
			ComplexTypes.voidType
		);
	}
}
#end
