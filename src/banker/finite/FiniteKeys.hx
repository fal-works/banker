package banker.finite;

#if macro
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using banker.array.ArrayExtension;
using banker.array.ArrayFunctionalExtension;

import sneaker.macro.PositionStack;
import sneaker.macro.ContextTools;
import sneaker.macro.EnumAbstractType;
import sneaker.macro.extensions.FieldExtension;
import banker.finite.FiniteKeysValidator.*;

class FiniteKeys {
	/**
		Entry point of the build macro.
		Add fields to the class, generating from values of `enumAbstractType`.

		@param keyTypeExpression Any enum abstract type.
	**/
	public static macro function from(keyTypeExpression: Expr): Fields {
		PositionStack.reset();

		final localClassResult = ContextTools.getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();

		setVerificationState(localClass);

		if (notVerified) {
			debug('Start to build.');
			debug('Resolving enum abstract type.');
		}
		final enumAbstractTypeResult = getEnumAbstractType(keyTypeExpression);
		if (enumAbstractTypeResult.isFailedWarn()) return null;
		final enumAbstractType = enumAbstractTypeResult.unwrap();
		if (notVerified) debug("  Resolved: " + enumAbstractType.name);

		final buildFields = Context.getBuildFields();

		if (notVerified) debug('Determine initial values from metadata.');
		final initialValueResult = getInitialValue(
			buildFields,
			enumAbstractType.name
		);
		if (initialValueResult.isFailedWarn()) return null;
		final initialValue = initialValueResult.unwrap();
		if (notVerified) debug('  Determined.');

		final keyValueTypes: KeyValueTypes = {
			key: {
				expression: keyTypeExpression,
				type: enumAbstractType.type,
				complex: enumAbstractType.toComplexType2()
			},
			value: {
				type: initialValue.type.toType(),
				complex: initialValue.type
			}
		};

		final valuesAreFinal = checkFinal(localClass.meta);
		final instances = enumAbstractType.getInstances();

		final constructorField = buildFields.removeFirst(
			FieldExtension.isNew,
			FiniteKeysField.nullField
		);
		final constructor = switch (constructorField.kind) {
			case FFun(func): func;
			default: FiniteKeysField.nullFunction;
		}

		final newFields = createNewFields(
			localClass,
			valuesAreFinal,
			instances,
			initialValue,
			keyValueTypes,
			constructor
		);

		if (notVerified) debug('End building.');

		return buildFields.concat(newFields);
	}

	/**
		@return `true` if the class has "final" metadata.
	**/
	static function checkFinal(metaAccess: MetaAccess): Bool {
		final valuesAreFinal = metaAccess.has('${MetadataName.finalValues}');

		if (notVerified) {
			if (valuesAreFinal) {
				debug('Found metadata: @${MetadataName.finalValues}');
				debug('Create read-only fields.');
			} else {
				debug('Metadata not specified: @${MetadataName.finalValues}');
				debug('Create writable fields.');
			}
		}

		return valuesAreFinal;
	}

	/**
		Creates the fields below:
		- Constructor (if absent)
		- Variables that correspond to enum abstract values
		- Map methods
		- Sequence methods
	**/
	static function createNewFields(
		localClass: ClassType,
		valuesAreFinal: Bool,
		instances: Array<ClassField>,
		initialValue: InitialValue,
		keyValueTypes: KeyValueTypes,
		constructor: Function
	): Fields {
		final fieldConverter = FiniteKeysField.getFieldConverter(
			initialValue,
			valuesAreFinal,
			keyValueTypes
		);
		final variables = instances.map(fieldConverter);

		final instanceNames = instances.map(getInstanceName);

		final mapMethods = if (valuesAreFinal)
			FiniteKeysMap.createReadOnlyFields(instanceNames, keyValueTypes);
		else
			FiniteKeysMap.createWritableFields(instanceNames, keyValueTypes);

		final sequenceMethods = FiniteKeysSequence.createSequenceMethods(
			instanceNames,
			keyValueTypes
		);

		final copyMethods = FiniteKeysCopy.createCopyMethods(
			instanceNames,
			keyValueTypes
		);

		final basicFields = [
			FiniteKeysField.createConstructor(
				constructor,
				instanceNames,
				initialValue,
				keyValueTypes
			),
			FiniteKeysField.createEntryCount(instances.length)
		];

		final newFields = [
			basicFields,
			variables,
			mapMethods,
			sequenceMethods,
			copyMethods
		].flatten();

		if (notVerified) {
			for (field in newFields) debug('  - ${field.name}');
			debug('  Created.');
		}

		return newFields;
	}

	static final getInstanceName = (instance: ClassField) -> instance.name;
}
#end
