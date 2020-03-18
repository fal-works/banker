package banker.finite;

#if macro
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using sneaker.macro.MetadataExtension;
using sneaker.macro.MacroCaster;

import sneaker.macro.ContextTools;
import sneaker.types.Result;
import sneaker.trier.ResultCatcher;

class FiniteKeysValidator {
	public static final catchLocalClass = new ResultCatcher(
		getLocalClass,
		Log(Warn)
	);

	public static final catchDefaultValue = new ResultCatcher(
		getDefaultValue,
		Log(Warn)
	);

	public static final catchEnumAbstractType = new ResultCatcher(
		getEnumAbstractType,
		Log(Warn)
	);

	static final catchReturnType = new ResultCatcher(
		getReturnType,
		Log(Warn)
	);

	static function getLocalClass(_: Any) {
		final localClassRef = Context.getLocalClass();

		return if (localClassRef != null)
			Ok(localClassRef.get());
		else
			Failed("Tried to process something that is not a class.");
	}

	static function getDefaultValue(metaAccess: MetaAccess): Result<DefaultValue, String> {
		final defaultValues = metaAccess.extractParameters(":banker.finiteKeys.default");
		final valuesLength = defaultValues.length;

		if (valuesLength == 1) {
			final expression = defaultValues[0];
			final type = Context.typeof(expression).toComplexType();
			debug("  Found default value.");
			return Ok(Value(expression, type));
		}

		if (valuesLength > 1)
			return Failed("Too many parameters in @:banker.finiteKeys.default metadata");

		final defaultValueFactories = metaAccess.extractParameters(":banker.finiteKeys.defaultFactory");
		final factoriesLength = defaultValueFactories.length;

		if (factoriesLength == 1) {
			final expression = defaultValueFactories[0];
			final type = Context.typeof(expression).toComplexType();
			final returnType = catchReturnType.run(type);
			if (returnType.failed) return Failed("A function is required in @:banker.finiteKeys.defaultFactory metadata");

			debug("  Found factory function for setting default values.");
			return Ok(Function(expression, returnType.unwrap()));
		}

		if (factoriesLength > 1)
			return Failed("Too many parameters in @:banker.finiteKeys.default metadata");

		debug("  Default value not specified. Set false as default.");
		return Ok(Value(macro false, (macro:Bool)));
	};

	static function getEnumAbstractType(
		parameter: Expr
	): Result<EnumAbstractType, String> {
		final type = ContextTools.tryGetType(parameter.toString());
		if (type == null) return Failed("Type not found");

		var abstractType: AbstractType;

		switch (type.toAbstractType()) {
			case Ok(v): abstractType = v;
			case Failed(message): return Failed(message);
		}

		return abstractType.toEnumAbstractType();
	};

	static function getReturnType(
		complexType: ComplexType
	): Result<ComplexType, String> {
		return switch complexType {
			case TFunction(_, returnType): Ok(returnType);
			default: Failed("Not a function");
		}
	}
}
#end
