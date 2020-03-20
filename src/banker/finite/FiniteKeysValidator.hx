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

	public static final catchInitialValue = new ResultCatcher(
		getInitialValue,
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
			Failed('Tried to process something that is not a class.');
	}

	static function getInitialValue(metaAccess: MetaAccess): Result<InitialValue, String> {
		final initialValues = metaAccess.extractParameters('${MetadataName.initialValue}');
		final valuesLength = initialValues.length;

		if (valuesLength == 1) {
			final expression = initialValues[0];
			final type = Context.typeof(expression).toComplexType();
			debug('  Found initial value.');
			return Ok(Value(expression, type));
		}

		if (valuesLength > 1)
			return Failed('Too many parameters in @${MetadataName.initialValue} metadata');

		final initialValueFactories = metaAccess.extractParameters('${MetadataName.initialFactory}');
		final factoriesLength = initialValueFactories.length;

		if (factoriesLength == 1) {
			final expression = initialValueFactories[0];
			final type = Context.typeof(expression).toComplexType();
			final returnType = catchReturnType.run(type);
			if (returnType.failed) return Failed('A function is required in @${MetadataName.initialFactory} metadata');

			debug('  Found factory function for setting initial values.');
			return Ok(Function(expression, returnType.unwrap()));
		}

		if (factoriesLength > 1)
			return Failed('Too many parameters in @${MetadataName.initialValue} metadata');

		debug('  Initial values not specified. Set false as initial value.');
		return Ok(Value(macro false, (macro:Bool)));
	};

	static function getEnumAbstractType(
		parameter: Expr
	): Result<EnumAbstractType, String> {
		final type = ContextTools.tryGetType(parameter.toString());
		if (type == null) return Failed('Type not found');

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
			default: Failed('Not a function');
		}
	}
}
#end
