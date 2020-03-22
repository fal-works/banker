package banker.finite;

#if macro
using sneaker.format.StringExtension;
using sneaker.macro.FieldExtension;

import haxe.macro.Expr;
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
		final newFields = ArrayTools.allocate(instances.length * 2 + 2);
		var i = 0;

		for (instance in instances) {
			newFields[i++] = fieldConverter(instance);
			newFields[i++] = createGet(instance);
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
		final newFields = ArrayTools.allocate(instances.length * 3 + 4);
		var i = 0;

		for (instance in instances) {
			newFields[i++] = fieldConverter(instance);
			newFields[i++] = createGet(instance);
			newFields[i++] = createSet(instance);
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

	static final createGetExpression = (name: String) -> macro this.$name;
	static final createGetterExpression = (name: String) -> macro() -> this.$name;
	static final createSetExpression = (name: String) -> macro this.$name = value;
	static final createSetterExpression = (name: String) -> macro value -> this.$name = value;

	static final getterDocumentation = 'Creates a function that gets the value for `key`.';
	static final setterDocumentation = 'Creates a function that sets the value for `key`.';

	static function createGet(instance: ClassField): Field
		return createIndividual(instance, getMethodName, noArgs, createGetExpression);

	static function createSet(instance: ClassField): Field
		return createIndividual(instance, setMethodName, valueArgs, createSetExpression);

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
