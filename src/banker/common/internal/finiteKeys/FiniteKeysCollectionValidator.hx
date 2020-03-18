package banker.common.internal.finiteKeys;

#if macro
using haxe.macro.ExprTools;
using sneaker.macro.MetadataExtension;
using sneaker.macro.MacroCaster;

import sneaker.macro.ContextTools;
import sneaker.types.Result;
import sneaker.trier.ResultCatcher;

class FiniteKeysCollectionValidator {
	public static final catchLocalClass = new ResultCatcher(
		getLocalClass,
		Log(Warn)
	);

	public static final catchDefaultValue = new ResultCatcher(
		getDefaultValue,
		Log(Warn)
	);

	public static final catchEnumAbstractParameter = new ResultCatcher(
		getEnumAbstractParameter,
		Log(Warn)
	);

	public static final catchEnumAbstractType = new ResultCatcher(
		getEnumAbstractType,
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

		if (defaultValues.length == 1)
			return Ok(Value(defaultValues[0]));

		if (defaultValues.length > 1) return
			Failed("Too many parameters in @:banker.finiteKeys.default metadata");

		final defaultValueFactories = metaAccess.extractParameters(":banker.finiteKeys.defaultFactory");

		if (defaultValueFactories.length == 0) return
			Failed("Either @:banker.finiteKeys.default or @:banker.finiteKeys.defaultFactory is mandatory.");

		if (defaultValueFactories.length > 1) return
			Failed("Too many parameters in @:banker.finiteKeys.default metadata");

		return Ok(Function(defaultValueFactories[0]));
	};

	static function getEnumAbstractParameter(
		metaAccess: MetaAccess
	): Result<Expr, String> {
		if (!metaAccess.has(":banker.finiteKeys.enumAbstract"))
			return Failed("Missing @:banker.finiteKeys.enumAbstract metadata");

		final parameters = metaAccess.extractParameters(":banker.finiteKeys.enumAbstract");
		final length = parameters.length;

		if (length == 0)
			return Failed("Missing parameters in @:banker.finiteKeys.enumAbstract metadata");

		if (length >= 2)
			return Failed("Too many parameters in @:banker.finiteKeys.enumAbstract metadata");

		return Ok(parameters[0]);
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
}
#end
