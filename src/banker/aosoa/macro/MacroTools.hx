package banker.aosoa.macro;

#if macro
using sneaker.format.StringExtension;

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import banker.aosoa.macro.MacroTypes;

class MacroTools {
	/**
		@param param `Type.TypeParameter`
		@return Enum `Expr.TypeParam` (instance `TPType`)
	**/
	public static function typeParameterToTypeParam(param: TypeParameter): TypeParam
		return TPType(Context.toComplexType(param.t));

	/**
		@param `Type.Ref<ClassType>`
		@return `Expr.TypePath`
	**/
	public static function typeRefToTypePath(typeRef: Ref<ClassType>): TypePath {
		final type = typeRef.get();
		return {
			pack: type.pack,
			name: type.name,
			params: type.params.map(typeParameterToTypeParam)
		}
	}

	/**
		Define new imports in the current module in which the macro was called.
	**/
	public static function defineImports(importExpressions: Array<ImportExpr>): Void {
		Context.defineModule(
			Context.getLocalModule(),
			[],
			Context.getLocalImports().concat(importExpressions),
			Context.getLocalUsing().map(typeRefToTypePath)
		);
	}

	/**
		Defines `subTypes` in the current module in which the macro was called.
	**/
	public static function defineSubType(subTypes: Array<TypeDefinition>): Void {
		Context.defineModule(
			Context.getLocalModule(),
			subTypes,
			Context.getLocalImports(),
			Context.getLocalUsing().map(typeRefToTypePath)
		);
	}

	/**
		@return Inforomation about the current module and package
		in which the macro was called.
	**/
	public static function getLocalModuleInfo(): ModuleInfo {
		final modulePath = Context.getLocalModule();
		final modulePathLastDotIndex = modulePath.lastIndexOfDot();
		final moduleName = modulePath.substr(modulePathLastDotIndex + 1);
		var packagePath: String;
		var packages: Array<String>;
		if (modulePathLastDotIndex >= 0) {
			packagePath = modulePath.substr(0, modulePathLastDotIndex);
			packages = packagePath.split(".");
		} else {
			packagePath = "";
			packages = [];
		}

		return {
			path: modulePath,
			name: moduleName,
			packagePath: packagePath,
			packages: packages
		}
	}
}
#end
