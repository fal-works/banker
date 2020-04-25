package banker.finite;

#if macro
/**
	Functions for creating copying methods.
**/
class FiniteKeysCopy {
	/**
		@return Fields of copying functions.
	**/
	public static function createCopyMethods(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Fields {
		return [
			createExportKeys(instanceNames, keyValueTypes),
			createExportValues(instanceNames, keyValueTypes),
		];
	}

	/**
		@return Function field `exportKeys()`.
	**/
	static function createExportKeys(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		return createCopy(
			instanceNames,
			keyValueTypes,
			exportKeysMethodName,
			keyElement,
			keyValueTypes.key.complex
		);
	}

	/**
		@return Function field `exportValues()`.
	**/
	static function createExportValues(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		return createCopy(
			instanceNames,
			keyValueTypes,
			exportValuesMethodName,
			valueElement,
			keyValueTypes.value.complex
		);
	}

	@:access(haxe.macro.TypeTools)
	static function createCopy(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes,
		methodName: String,
		element: (keyExpression: Expr, keyName: String) -> Expr,
		elementType: ComplexType
	): Field {
		final keyTypeExpression = keyValueTypes.key.expression;

		final instanceCount = instanceNames.length;
		final lastK = instanceCount - 1;
		final elementExpressions: Array<Expr> = Arrays.allocate(instanceCount * 2 - 1);

		for (k in 0...instanceCount) {
			final name = instanceNames[k];
			final key = macro $keyTypeExpression.$name;
			final elementExpression = element(keyTypeExpression, name);
			final index = k * 2;
			elementExpressions[index] = macro vector[i] = $elementExpression;
			if (k < lastK) elementExpressions[index + 1] = macro ++i;
		}

		final expressions: Array<Expr> = [];
		expressions.push(macro final vector = new banker.vector.internal.RawVector<$elementType>($v{instanceCount}));
		expressions.push(macro var i = 0);
		expressions.push(macro $b{elementExpressions});
		expressions.push(macro return vector);

		final fieldType: FieldType = FFun({
			args: [],
			ret: (macro:banker.vector.Vector<$elementType>),
			expr: macro $b{expressions}
		});

		return {
			name: methodName,
			kind: fieldType,
			pos: Context.currentPos(),
			access: [APublic, AInline]
		};
	}

	static final exportKeysMethodName = "exportKeys";
	static final exportValuesMethodName = "exportValues";

	static function keyElement(keyExpression: Expr, keyName: String)
		return macro $keyExpression.$keyName;

	static function valueElement(keyExpression: Expr, keyName: String)
		return macro this.$keyName;
}
#end
