package banker.finite;

#if macro
import haxe.macro.Expr;
import banker.array.ArrayTools;

/**
	Functions for creating iterating methods.
**/
class FiniteKeysSequence {
	/**
		@return Fields of iterating functions.
	**/
	public static function createSequenceMethods(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Fields {
		return [
			createForEachKey(instanceNames, keyValueTypes),
			createForEachValue(instanceNames, keyValueTypes),
			createForEach(instanceNames, keyValueTypes)
		];
	}

	/**
		@return Function field `forEachKey(callback: K -> Void)`.
	**/
	static function createForEachKey(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		return createFunctional(
			instanceNames,
			keyValueTypes,
			forEachKeyMethodName,
			forEachKeyCallbackType(keyValueTypes),
			forEachKeyRunCallback
		);
	}

	/**
		@return Function field `forEachValue(callback: V -> Void)`.
	**/
	static function createForEachValue(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		return createFunctional(
			instanceNames,
			keyValueTypes,
			forEachValueMethodName,
			forEachValueCallbackType(keyValueTypes),
			forEachValueRunCallback
		);
	}

	/**
		@return Function field `forEach(callback: (K, V) -> Void)`.
	**/
	static function createForEach(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		return createFunctional(
			instanceNames,
			keyValueTypes,
			forEachMethodName,
			forEachCallbackType(keyValueTypes),
			forEachRunCallback
		);
	}

	@:access(haxe.macro.TypeTools)
	static function createFunctional(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes,
		methodName: String,
		callbackType: ComplexType,
		createCallback: (keyExpression: Expr, keyName: String) -> Expr
	): Field {
		final keyTypeExpression = keyValueTypes.key.expression;
		final expressions: Array<Expr> = ArrayTools.allocate(instanceNames.length);
		for (i in 0...instanceNames.length) {
			final name = instanceNames[i];
			final key = macro $keyTypeExpression.$name;
			expressions[i] = createCallback(key, name);
		}

		final fieldType: FieldType = FFun({
			args: [{
				name: "callback",
				type: callbackType
			}],
			ret: (macro:Void),
			expr: macro $b{expressions}
		});

		return {
			name: methodName,
			kind: fieldType,
			pos: Context.currentPos(),
			access: [APublic, AInline]
		};
	}

	static final forEachKeyMethodName = "forEachKey";
	static final forEachValueMethodName = "forEachValue";
	static final forEachMethodName = "forEach";

	static function forEachKeyCallbackType(keyValueTypes: KeyValueTypes): ComplexType {
		return TFunction([TNamed("key", keyValueTypes.key.complex)], (macro:Void));
	}

	static function forEachValueCallbackType(keyValueTypes: KeyValueTypes): ComplexType {
		return TFunction(
			[TNamed("value", keyValueTypes.value.complex)],
			(macro:Void)
		);
	}

	static function forEachCallbackType(keyValueTypes: KeyValueTypes): ComplexType {
		return TFunction([
			TNamed("key", keyValueTypes.key.complex),
			TNamed("value", keyValueTypes.value.complex)
		], (macro:Void));
	}

	static function forEachKeyRunCallback(keyExpression: Expr, keyName: String)
		return macro callback($keyExpression);

	static function forEachValueRunCallback(keyExpression: Expr, keyName: String)
		return macro callback(this.$keyName);

	static function forEachRunCallback(keyExpression: Expr, keyName: String)
		return macro callback($keyExpression, this.$keyName);
}
#end
