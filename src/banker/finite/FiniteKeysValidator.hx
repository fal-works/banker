package banker.finite;

#if macro
using haxe.macro.ExprTools;
using sneaker.macro.MacroCaster;
using banker.array.ArrayFunctionalExtension;

import sneaker.macro.ContextTools;
import sneaker.macro.MacroResult;

class FiniteKeysValidator {
	/**
		Tries to resolve `typeExpression` as `EnumAbstractType`.
	**/
	public static function getEnumAbstractType(
		typeExpression: Expr
	): MacroResult<EnumAbstractType> {
		final type = ContextTools.tryGetType(typeExpression.toString());
		if (type == null) return Failed('Type not found', typeExpression.pos);

		final abstractType = switch (type.toAbstractType()) {
			case Ok(v): v;
			case Failed(message): return Failed(message, typeExpression.pos);
		}

		return switch (abstractType.toEnumAbstractType()) {
			case Ok(v): Ok(v);
			case Failed(message): Failed(message, typeExpression.pos);
		}
	};

	/**
		Tries to get either a variable or function for setting initial values for each key.
	**/
	public static function getInitialValue(
		buildFields: Fields,
		enumAbstractType: EnumAbstractType
	): MacroResult<InitialValue> {
		final initialValueField = buildFields.findFirst(
			fieldIsInitialValue,
			dummyField
		);

		if (initialValueField == dummyField) {
			debug('  Initial values not specified. Set false as initial value.');
			return Ok(Value(macro false, (macro:Bool)));
		}

		switch (initialValueField.kind) {
			case FVar(type, expression):
				debug('  Found a variable.');
				return Ok(Value(expression, type));

			case FFun(func):
				debug('  Found a factory function.');
				final position = initialValueField.pos;
				final expression = func.expr;
				if (expression == null) return Failed(
					'Missing function body',
					position
				);

				return switch (func.args.length) {
					case 0:
						Failed(
							'Missing argument of type ${enumAbstractType.name}',
							position
						);
					case 1:
						Ok(Function(initialValueField.name, func.ret));
					default:
						Failed('Too many arguments', position);
				}

			default:
				return Failed('You cannot specify property', initialValueField.pos);
		}
	};

	static final dummyField: Field = {
		name: "",
		kind: FVar(null, null),
		pos: Context.currentPos()
	};

	static function metadataIsInitialValue(entry: MetadataEntry): Bool
		return entry.name == MetadataName.initialValue;

	static function fieldIsInitialValue(field: Field): Bool {
		if (field.name == "initialValue") return true;
		final meta = field.meta;
		if (meta == null) return false;
		return meta.hasAny(metadataIsInitialValue);
	}
}
#end
