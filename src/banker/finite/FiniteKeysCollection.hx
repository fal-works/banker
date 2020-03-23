package banker.finite;

#if macro
using sneaker.format.StringExtension;

/**
	Functions for creating get/set methods.
**/
class FiniteKeysCollection {
	/**
		(Currently not used)
		@return Function field for specific `instance`.
	**/
	public static function createIndividual(
		instance: ClassField,
		prefix: String,
		arguments: Array<FunctionArg>,
		createReturnValueExpression: (name: String) -> Expr
	): Field {
		final name = instance.name.camelToPascal();
		final returnValue = createReturnValueExpression(name);

		return {
			name: '$prefix$name',
			kind: FFun({
				args: arguments,
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
		keyValueTypes: KeyValueTypes,
		methodName: String,
		arguments: Array<FunctionArg>,
		createCaseExpression: (name: String) -> Expr,
		returnType: ComplexType
	): Field {
		final keyType = keyValueTypes.key.expression;

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
			args: arguments,
			ret: returnType,
			expr: macro return $switchExpression
		});

		return {
			name: methodName,
			kind: fieldType,
			pos: Context.currentPos(),
			access: [APublic, AInline]
		};
	}
}
#end
