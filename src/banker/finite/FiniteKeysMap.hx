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
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Fields {
		return [
			createSwitchGet(instanceNames, keyValueTypes),
			createSwitchGetter(instanceNames, keyValueTypes)
		];
	}

	/**
		Create fields for a finite keys map. Should be called if the values are not `final`.
		@return Variables, read-access methods and write-access methods.
	**/
	public static function createWritableFields(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Fields {
		return [
			createSwitchGet(instanceNames, keyValueTypes),
			createSwitchGetter(instanceNames, keyValueTypes),
			createSwitchSet(instanceNames, keyValueTypes),
			createSwitchSetter(instanceNames, keyValueTypes)
		];
	}

	static final getMethodName = "get";
	static final getterMethodName = "getter";
	static final setMethodName = "set";
	static final setterMethodName = "setter";

	static function noArgs(types: KeyValueTypes): Array<FunctionArg>
		return [];

	static function keyArgs(types: KeyValueTypes): Array<FunctionArg>
		return [{ name: "key", type: types.key.complex }];

	static function valueArgs(types: KeyValueTypes): Array<FunctionArg>
		return [{ name: "value", type: types.value.complex }];

	static function keyValueArgs(types: KeyValueTypes): Array<FunctionArg>
		return [
			{ name: "key", type: types.key.complex },
			{ name: "value", type: types.value.complex }
		];

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

	static function createSwitchGet(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		final returnType = keyValueTypes.value.complex;

		return createSwitch(
			instanceNames,
			keyValueTypes,
			getMethodName,
			keyArgs(keyValueTypes),
			createGetExpression,
			returnType
		);
	}

	static function createSwitchGetter(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		final valueType = keyValueTypes.value.complex;
		final returnType = macro:() -> $valueType;

		return createSwitch(
			instanceNames,
			keyValueTypes,
			getterMethodName,
			keyArgs(keyValueTypes),
			createGetterExpression,
			returnType
		).setDoc(getterDocumentation);
	}

	static function createSwitchSet(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		final returnType = keyValueTypes.value.complex;

		return createSwitch(
			instanceNames,
			keyValueTypes,
			setMethodName,
			keyValueArgs(keyValueTypes),
			createSetExpression,
			returnType
		);
	}

	static function createSwitchSetter(
		instanceNames: Array<String>,
		keyValueTypes: KeyValueTypes
	): Field {
		final valueType = keyValueTypes.value.complex;
		final returnType = macro:(value: $valueType) -> Void;

		return createSwitch(
			instanceNames,
			keyValueTypes,
			setterMethodName,
			keyArgs(keyValueTypes),
			createSetterExpression,
			returnType
		).setDoc(setterDocumentation);
	}
}
#end
