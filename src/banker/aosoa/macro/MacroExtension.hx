package banker.aosoa.macro;

#if macro
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using banker.array.ArrayExtension;

import banker.aosoa.macro.ComplexTypes.*;

class MacroExtension {
	public static function compareTypeParam(a: TypeParam, b: TypeParam): Bool {
		return switch a {
			case TPType(aType):
				switch b {
					case TPType(bType): unifyComplex(aType, bType);
					case TPExpr(bExpr): false;
				}
			case TPExpr(aExpr):
				switch b {
					case TPType(aType): false;
					case TPExpr(bExpr): aExpr == bExpr;
				}
		}
	}

	public static function unifyComplex(a: ComplexType, b: ComplexType): Bool {
		return if (a == null)
			throw "a is null."
		else if (b == null)
			throw "b is null."
		else
			a.toType().unify(b.toType());
	}

	public static function argumentIsWriteIndex(argument: FunctionArg): Bool
		return argument.name == "i" && unifyComplex(argument.type, intType);

	public static function argumentIsDisuse(argument: FunctionArg): Bool
		return argument.name == "disuse" && unifyComplex(argument.type, boolType);
}
#end
