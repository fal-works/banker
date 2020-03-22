package banker.finite;

#if macro
using sneaker.macro.extensions.FieldExtension;

import banker.array.ArrayTools;
import banker.finite.FiniteKeysCollection.*;

/**
	Functions for creating fields of a finite keys map.
**/
class FiniteKeysMap {
	/**
		Create fields for a finite keys map. Should be called if the values are `final`.
		@return Variables and read-access methods.
	**/
	public static function createReadOnlyFields(
		instances: Array<ClassField>,
		fieldConverter: ClassField->Field,
		keyType: Expr,
		keyComplexType: ComplexType,
		valueComplexType: ComplexType
	): Fields {
		final newFields = ArrayTools.allocate(instances.length + 2);
		var i = 0;

		for (instance in instances) {
			newFields[i++] = fieldConverter(instance);
		}

		newFields[i++] = createSwitchGet(instances, keyType, keyComplexType, valueComplexType);
		newFields[i++] = createSwitchGetter(instances, keyType, keyComplexType, valueComplexType);

		return newFields;
	}

	/**
		Create fields for a finite keys map. Should be called if the values are not `final`.
		@return Variables, read-access methods and write-access methods.
	**/
	public static function createWritableFields(
		instances: Array<ClassField>,
		fieldConverter: ClassField->Field,
		keyType: Expr,
		keyComplexType: ComplexType,
		valueComplexType: ComplexType
	): Fields {
		final newFields = ArrayTools.allocate(instances.length + 4);
		var i = 0;

		for (instance in instances) {
			newFields[i++] = fieldConverter(instance);
		}

		newFields[i++] = createSwitchGet(instances, keyType, keyComplexType, valueComplexType);
		newFields[i++] = createSwitchGetter(instances, keyType, keyComplexType, valueComplexType);
		newFields[i++] = createSwitchSet(instances, keyType, keyComplexType, valueComplexType);
		newFields[i++] = createSwitchSetter(instances, keyType, keyComplexType, valueComplexType);

		return newFields;
	}

	static final getMethodName = "get";
	static final getterMethodName = "getter";
	static final setMethodName = "set";
	static final setterMethodName = "setter";

	static function noArgs(key: ComplexType, value: ComplexType):  Array<FunctionArg>
		return [];
	static function keyArgs(key: ComplexType, value: ComplexType): Array<FunctionArg>
		return [{ name: "key", type: key }];
	static function valueArgs(key: ComplexType, value: ComplexType): Array<FunctionArg>
		return [{ name: "value", type: value }];
	static function keyValueArgs(key: ComplexType, value: ComplexType): Array<FunctionArg>
		return [{ name: "key", type: key }, { name: "value", type: value }];

	static function createGetExpression(name: String): Expr {
		return macro this.$name;
	}
	static function createGetterExpression(name: String): Expr {
		return macro() -> this.$name;
	}
	static function createSetExpression(name: String): Expr {
		return macro this.$name = value;
	}
	static function createSetterExpression(name: String): Expr {
		return macro value -> this.$name = value;
	}

	static final getterDocumentation = 'Creates a function that gets the value for `key`.';
	static final setterDocumentation = 'Creates a function that sets the value for `key`.';

	static function createSwitchGet(instances: Array<ClassField>, keyType: Expr, keyComplexType: ComplexType, valueComplexType: ComplexType)
		return createSwitch(
			instances,
			keyType,
			getMethodName,
			keyArgs(keyComplexType, valueComplexType),
			createGetExpression,
			valueComplexType
		);

	static function createSwitchGetter(instances: Array<ClassField>, keyType: Expr, keyComplexType: ComplexType,valueComplexType: ComplexType)
		return createSwitch(
			instances,
			keyType,
			getterMethodName,
			keyArgs(keyComplexType, valueComplexType),
			createGetterExpression,
			(macro: () -> $valueComplexType)
		).setDoc(getterDocumentation);

	static function createSwitchSet(instances: Array<ClassField>, keyType: Expr, keyComplexType: ComplexType,valueComplexType: ComplexType)
		return createSwitch(
			instances,
			keyType,
			setMethodName,
			keyValueArgs(keyComplexType, valueComplexType),
			createSetExpression,
			valueComplexType
		);

	static function createSwitchSetter(instances: Array<ClassField>, keyType: Expr, keyComplexType: ComplexType,valueComplexType: ComplexType)
		return createSwitch(
			instances,
			keyType,
			setterMethodName,
			keyArgs(keyComplexType, valueComplexType),
			createSetterExpression,
			(macro: (value: $valueComplexType) -> Void)
		).setDoc(setterDocumentation);
}
#end
