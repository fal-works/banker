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
		keyType: Expr
	): Fields {
		final newFields = ArrayTools.allocate(instances.length + 2);
		var i = 0;

		for (instance in instances) {
			newFields[i++] = fieldConverter(instance);
		}

		newFields[i++] = createSwitchGet(instances, keyType);
		newFields[i++] = createSwitchGetter(instances, keyType);

		return newFields;
	}

	/**
		Create fields for a finite keys map. Should be called if the values are not `final`.
		@return Variables, read-access methods and write-access methods.
	**/
	public static function createWritableFields(
		instances: Array<ClassField>,
		fieldConverter: ClassField->Field,
		keyType: Expr
	): Fields {
		final newFields = ArrayTools.allocate(instances.length + 4);
		var i = 0;

		for (instance in instances) {
			newFields[i++] = fieldConverter(instance);
		}

		newFields[i++] = createSwitchGet(instances, keyType);
		newFields[i++] = createSwitchGetter(instances, keyType);
		newFields[i++] = createSwitchSet(instances, keyType);
		newFields[i++] = createSwitchSetter(instances, keyType);

		return newFields;
	}

	static final getMethodName = "get";
	static final getterMethodName = "getter";
	static final setMethodName = "set";
	static final setterMethodName = "setter";

	static final noArgs: Array<String> = [];
	static final keyArgs = ["key"];
	static final valueArgs = ["value"];
	static final keyValueArgs = ["key", "value"];

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

	static function createSwitchGet(instances: Array<ClassField>, keyType: Expr)
		return createSwitch(
			instances,
			keyType,
			getMethodName,
			keyArgs,
			createGetExpression
		);

	static function createSwitchGetter(instances: Array<ClassField>, keyType: Expr)
		return createSwitch(
			instances,
			keyType,
			getterMethodName,
			keyArgs,
			createGetterExpression
		).setDoc(getterDocumentation);

	static function createSwitchSet(instances: Array<ClassField>, keyType: Expr)
		return createSwitch(
			instances,
			keyType,
			setMethodName,
			keyValueArgs,
			createSetExpression
		);

	static function createSwitchSetter(instances: Array<ClassField>, keyType: Expr)
		return createSwitch(
			instances,
			keyType,
			setterMethodName,
			keyArgs,
			createSetterExpression
		).setDoc(setterDocumentation);
}
#end
