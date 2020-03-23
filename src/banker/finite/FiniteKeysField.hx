package banker.finite;

#if macro
/**
	Common functions for `FiniteKeys` macro.
**/
class FiniteKeysField {
	/**
		@return Function that converts an enum abstract instance to an initialized variable field.
	**/
	public static function getFieldConverter(
		initialValue: InitialValue,
		valuesAreFinal: Bool,
		keyValueTypes: KeyValueTypes
	): ClassField->Field {
		final fieldAccess: Array<Access> = [APublic];
		if (valuesAreFinal) fieldAccess.push(AFinal);

		final keyType = keyValueTypes.key.expression;

		return switch (initialValue.kind) {
			case Value(value):
				final fieldType:FieldType = FVar(initialValue.type, null);
				function(instance): Field return {
					name: instance.name,
					kind: fieldType,
					pos: instance.pos,
					access: fieldAccess,
					doc: instance.doc
				}
			case Function(functionName):
				function(instance): Field return {
					final name = instance.name;
					return {
						name: name,
						kind: FVar(
							initialValue.type,
							null
						),
						pos: instance.pos,
						access: fieldAccess,
						doc: instance.doc
					};
				}
		}
	}

	/**
		@return An empty public function field with name "new".
	**/
	public static function createConstructor(
		existingExpression: Null<Expr>,
		instances: Array<ClassField>,
		initialValue: InitialValue,
		keyValueTypes: KeyValueTypes
	): Field {
		final expressions: Array<Expr> = [];
		if (existingExpression != null) expressions.push(existingExpression);

		final keyType = keyValueTypes.key.expression;

		switch (initialValue.kind) {
			case Value(valueExpression):
				for (instance in instances) {
					final name = instance.name;
					expressions.push(macro this.$name = $valueExpression);
				}
			case Function(functionName):
				for (instance in instances) {
					final name = instance.name;
					expressions.push(macro this.$name = $i{functionName}($keyType.$name));
				}
		}

		return {
			name: "new",
			kind: FFun({
				args: [],
				ret: null,
				expr: macro $b{expressions}
			}),
			access: [APublic],
			pos: Context.currentPos()
		};
	}
}
#end
