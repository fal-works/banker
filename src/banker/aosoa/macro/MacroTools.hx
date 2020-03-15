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
		@return Information about the current module and package
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

	/**
		Defines `typeDefinition` as a sub-type in the current module in which the macro was called.
		@return `path`: TypePath of the type. `pathString`: Dot-separated path of the type.
	**/
	public static function defineSubTypes(typeDefinitions: Array<TypeDefinition>): Array<DefinedType> {
		final localModule = getLocalModuleInfo();

		Context.defineModule(
			Context.getLocalModule(),
			typeDefinitions,
			Context.getLocalImports(),
			Context.getLocalUsing().map(typeRefToTypePath)
		);

		final definedTypes: Array<DefinedType> = [];

		for (i in 0...typeDefinitions.length) {
			final typeDefinition = typeDefinitions[i];

			typeDefinition.pack = localModule.packages;

			final subTypeName = typeDefinition.name;

			final path: TypePath = {
				pack: localModule.packages,
				name: localModule.name,
				sub: subTypeName
			};

			final definedType: DefinedType = {
				path: path,
				pathString: '${localModule.path}.${subTypeName}',
				complex: TPath(path)
			};
			definedTypes.push(definedType);
		}

		return definedTypes;
	}
}
#end
