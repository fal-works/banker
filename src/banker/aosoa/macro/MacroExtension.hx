package banker.aosoa.macro;

#if macro
using banker.array.ArrayExtension;

class MacroExtension {
	public static function compareTypeParam(a: TypeParam, b: TypeParam): Bool {
		return switch a {
			case TPType(aType):
				switch b {
					case TPType(bType): compareComplexType(aType, bType);
					case TPExpr(bExpr): false;
				}
			case TPExpr(aExpr):
				switch b {
					case TPType(aType): false;
					case TPExpr(bExpr): aExpr == bExpr;
				}
		}
	}

	public static function compareComplexType(a: ComplexType, b: ComplexType): Bool {
		return switch a {
			case TPath(aPath):
				switch b {
					case TPath(bPath):
						if (aPath.name != bPath.name || aPath.sub != bPath.sub) false;
						else if (!aPath.pack.equals(bPath.pack)) {
							false;
						}
						else {
							final aParams = aPath.params;
							final bParams = bPath.params;
							if (aParams == null) bParams == null;
							else if (bParams == null) aParams == null;
							else aParams.compare(bParams, compareTypeParam);
						}
					default: false;
				}
			default: false;
		}
	}
}
#end
