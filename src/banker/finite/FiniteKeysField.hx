package banker.finite;

#if macro
/**
	Common functions for `FiniteKeys` macro.
**/
class FiniteKeysField {
	/**
		Null object for `Expr.Field`.
	**/
	public static final nullField: Field = {
		name: "",
		kind: FVar(null, null),
		pos: Context.currentPos()
	};

	/**
		Null object for `Expr.Function`.
	**/
	public static final nullFunction: Function = {
		args: [],
		ret: null,
		expr: macro $b{[]}
	};

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
						kind: FVar(initialValue.type, null),
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
		existingConstructor: Function,
		instanceNames: Array<String>,
		initialValue: InitialValue,
		keyValueTypes: KeyValueTypes
	): Field {
		final arguments = existingConstructor.args;
		final existingExpression = existingConstructor.expr;
		final expressions = if (existingExpression != null) [existingExpression] else [];

		final keyType = keyValueTypes.key.expression;

		switch (initialValue.kind) {
			case Value(valueExpression):
				for (name in instanceNames)
					expressions.push(macro this.$name = $valueExpression);
			case Function(functionName):
				for (name in instanceNames)
					expressions.push(macro this.$name = $i{functionName}($keyType.$name));
		}

		return {
			name: "new",
			kind: FFun({
				args: arguments,
				ret: null,
				expr: macro $b{expressions}
			}),
			access: [APublic],
			pos: Context.currentPos()
		};
	}

	/**
		@return A static variable `entryCount`,
		of which value is the number of enum abstract instances.
	**/
	public static function createEntryCount(instanceCount: Int): Field {
		return {
			name: "entryCount",
			kind: FVar((macro:Int), macro $v{instanceCount}),
			access: [
				APublic,
				AInline,
				AFinal,
				AStatic
			],
			pos: Context.currentPos()
		};
	}
}
#end
