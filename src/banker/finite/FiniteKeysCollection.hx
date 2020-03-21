package banker.finite;

#if macro
using sneaker.format.StringExtension;

import haxe.macro.Expr;

class FiniteKeysCollection {
	/**
		@return Getter field for specific `instance`.
	**/
	public static function createIndividual(
		instance: ClassField,
		prefix: String,
		argumentNames: Array<String>,
		createReturnValueExpression: (name: String) -> Expr
	): Field {
		final name = instance.name.camelToPascal();
		final returnValue = createReturnValueExpression(name);

		return {
			name: '$prefix$name',
			kind: FFun({
				args: argumentNames.map(createArgument),
				ret: null,
				expr: macro return $returnValue
			}),
			pos: instance.pos,
			access: [APublic, AInline]
		}
	}

	/**
		@return Function field using `switch` with a given key.
	**/
	public static function createSwitch(
		instances: Array<ClassField>,
		keyType: Expr,
		methodName: String,
		argumentNames: Array<String>,
		createCaseExpression: (name: String) -> Expr
	): Field {
		final cases: Array<Case> = [for (instance in instances) {
			final name = instance.name;
			{
				values: [macro $keyType.$name],
				expr: createCaseExpression(name)
			};
		}];
		final switchExpression: Expr = {
			expr: ESwitch(macro key, cases, null),
			pos: Context.currentPos()
		};
		final fieldType: FieldType = FFun({
			args: argumentNames.map(createArgument),
			ret: null,
			expr: macro return $switchExpression
		});

		return {
			name: methodName,
			kind: fieldType,
			pos: Context.currentPos(),
			access: [APublic, AInline]
		};
	}

	static function createArgument(name: String): FunctionArg
		return { name: name, type: null };
}
#end
