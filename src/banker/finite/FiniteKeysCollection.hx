package banker.finite;

#if macro
using sneaker.format.StringExtension;

import haxe.macro.Expr;
import haxe.macro.TypeTools;
import banker.array.ArrayTools;

/**
	Functions for creating get/set methods.
**/
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

	/**
		@return Function field `forEach(callback: (K, V) -> Void)`.
	**/
	public static function createForEach(
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

	static function createArgument(name: String): FunctionArg
		return { name: name, type: null };

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

	static final forEachMethodName = "forEach";

	static function forEachCallbackType(
		keyType: ComplexType,
		valueType: ComplexType
	): ComplexType {
		return TFunction(
			[TNamed("key", keyType), TNamed("value", valueType)],
			(macro:Void)
		);
	}

	static function forEachRunCallback(keyExpression: Expr, keyName: String)
		return macro callback($keyExpression, this.$keyName);
}
#end
