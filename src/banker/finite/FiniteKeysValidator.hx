package banker.finite;

#if macro
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using sneaker.macro.MetadataExtension;
using sneaker.macro.MacroCaster;

import sneaker.macro.ContextTools;
import sneaker.macro.MacroResult;

class FiniteKeysValidator {
	public static function getLocalClass(): MacroResult<ClassType> {
		final localClassRef = Context.getLocalClass();

		return if (localClassRef != null)
			Ok(localClassRef.get());
		else
			Failed(
				'Tried to process something that is not a class.',
				Context.currentPos()
			);
	}

	public static function getInitialValue(
		args: { metaAccess: MetaAccess, enumAbstractType: EnumAbstractType }
	): MacroResult<InitialValue> {
		final metaAccess = args.metaAccess;
		final enumAbstractType = args.enumAbstractType;

		final initialValues = metaAccess.extractParameters('${MetadataName.initialValue}');
		final valuesLength = initialValues.length;

		if (valuesLength == 1) {
			final expression = initialValues[0];
			final type = Context.typeof(expression).toComplexType();
			debug('  Found initial value.');
			return Ok(Value(expression, type));
		}

		if (valuesLength > 1)
			return Failed(
				'Too many parameters in @${MetadataName.initialValue} metadata',
				initialValues[0].pos
			);

		final factories = metaAccess.extractParameters('${MetadataName.initialFactory}');
		final factoriesLength = factories.length;

		if (factoriesLength == 1) {
			final expression = factories[0];
			final type = Context.typeof(expression).toComplexType();

			return switch type {
				case TFunction(arguments, returnType):
					switch (arguments.length) {
						case 0:
							Failed(
								'Missing argument of type ${${enumAbstractType.name}}',
								expression.pos
							);
						case 1:
							debug('  Found factory function for setting initial values.');
							return Ok(Function(expression, returnType));
						default:
							Failed('Too many arguments', expression.pos);
					}
				default: Failed('Not a function', expression.pos);
			}
		}

		if (factoriesLength > 1)
			return Failed(
				'Too many parameters in @${MetadataName.initialValue} metadata',
				factories[0].pos
			);

		debug('  Initial values not specified. Set false as initial value.');
		return Ok(Value(macro false, (macro:Bool)));
	};

	public static function getEnumAbstractType(
		parameter: Expr
	): MacroResult<EnumAbstractType> {
		final type = ContextTools.tryGetType(parameter.toString());
		if (type == null) return Failed('Type not found', parameter.pos);

		var abstractType: AbstractType;

		switch (type.toAbstractType()) {
			case Ok(v): abstractType = v;
			case Failed(message): return Failed(message, parameter.pos);
		}

		return switch (abstractType.toEnumAbstractType()) {
			case Ok(v): Ok(v);
			case Failed(message): Failed(message, parameter.pos);
		}
	};
}
#end
