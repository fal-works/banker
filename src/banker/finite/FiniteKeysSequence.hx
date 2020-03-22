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
		instances: Array<ClassField>,
		keyTypeExpression: Expr,
		keyType: ComplexType,
		valueType: ComplexType
	): Fields {
		return [
			createForEachKey(instances, keyTypeExpression, keyType, valueType),
			createForEach(instances, keyTypeExpression, keyType, valueType)
		];
	}

	/**
		@return Function field `forEachKey(callback: K -> Void)`.
	**/
	static function createForEachKey(
		instances: Array<ClassField>,
		keyTypeExpression: Expr,
		keyType: ComplexType,
		valueType: ComplexType
	): Field {
		return createFunctional(
			instances,
			keyTypeExpression,
			forEachKeyMethodName,
			forEachKeyCallbackType(keyType, valueType),
			forEachKeyRunCallback
		);
	}

	/**
		@return Function field `forEachValue(callback: V -> Void)`.
	**/
	static function createForEachValue(
		instances: Array<ClassField>,
		keyTypeExpression: Expr,
		keyType: ComplexType,
		valueType: ComplexType
	): Field {
		return createFunctional(
			instances,
			keyTypeExpression,
			forEachValueMethodName,
			forEachValueCallbackType(keyType, valueType),
			forEachValueRunCallback
		);
	}

	/**
		@return Function field `forEach(callback: (K, V) -> Void)`.
	**/
	static function createForEach(
		instances: Array<ClassField>,
		keyTypeExpression: Expr,
		keyType: ComplexType,
		valueType: ComplexType
	): Field {
		return createFunctional(
			instances,
			keyTypeExpression,
			forEachMethodName,
			forEachCallbackType(keyType, valueType),
			forEachRunCallback
		);
	}

	@:access(haxe.macro.TypeTools)
	static function createFunctional(
		instances: Array<ClassField>,
		keyTypeExpression: Expr,
		methodName: String,
		callbackType: ComplexType,
		createCallback: (keyExpression: Expr, keyName: String) -> Expr
	): Field {
		final expressions: Array<Expr> = ArrayTools.allocate(instances.length);
		for (i in 0...instances.length) {
			final name = instances[i].name;
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

	static function forEachKeyCallbackType(
		keyType: ComplexType,
		valueType: ComplexType
	): ComplexType {
		return TFunction(
			[TNamed("key", keyType)],
			(macro:Void)
		);
	}
	static function forEachValueCallbackType(
		keyType: ComplexType,
		valueType: ComplexType
	): ComplexType {
		return TFunction(
			[TNamed("value", valueType)],
			(macro:Void)
		);
	}
	static function forEachCallbackType(
		keyType: ComplexType,
		valueType: ComplexType
	): ComplexType {
		return TFunction(
			[TNamed("key", keyType), TNamed("value", valueType)],
			(macro:Void)
		);
	}

	static function forEachKeyRunCallback(keyExpression: Expr, keyName: String)
		return macro callback($keyExpression);

	static function forEachValueRunCallback(keyExpression: Expr, keyName: String)
		return macro callback(this.$keyName);

	static function forEachRunCallback(keyExpression: Expr, keyName: String)
		return macro callback($keyExpression, this.$keyName);
}
#end
