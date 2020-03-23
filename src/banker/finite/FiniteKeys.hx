package banker.finite;

#if macro
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using banker.array.ArrayExtension;

import sneaker.macro.PositionStack;
import sneaker.macro.ContextTools.getLocalClass;
import sneaker.macro.EnumAbstractType;
import banker.finite.FiniteKeysValidator.*;

class FiniteKeys {
	/**
		Add fields to the class, generating from instances of `enumAbstractType`.

		@param keyTypeExpression Any enum abstract type.
	**/
	public static macro function from(keyTypeExpression: Expr): Fields {
		PositionStack.reset();

		final localClassResult = getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();

		setVerificationState(localClass);
		if (notVerified) debug('Start to build.');

		final metaAccess = localClass.meta;

		if (notVerified) debug('Resolving enum abstract type.');
		final enumAbstractTypeResult = getEnumAbstractType(keyTypeExpression);
		if (enumAbstractTypeResult.isFailedWarn()) return null;
		final enumAbstractType = enumAbstractTypeResult.unwrap();
		if (notVerified) debug("  Resolved: " + enumAbstractType.name);

		final buildFields = Context.getBuildFields();
		final instances = enumAbstractType.getInstances();

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

		final fieldConverter = FiniteKeysField.getFieldConverter(
			initialValue,
			valuesAreFinal,
			keyValueTypes
		);

		final newFields = if (valuesAreFinal)
			FiniteKeysMap.createReadOnlyFields(
				instances,
				fieldConverter,
				keyValueTypes
			);
		else
			FiniteKeysMap.createWritableFields(
				instances,
				fieldConverter,
				keyValueTypes
			);

		final sequenceFields = FiniteKeysSequence.createSequenceMethods(
			instances,
			keyValueTypes
		);
		newFields.pushFromArray(sequenceFields);

		if (localClass.constructor == null)
			newFields.push(FiniteKeysField.createConstructor());

		if (notVerified) {
			for (field in newFields) debug('  - ${field.name}');
			debug('  Created.');
			debug('End building.');
		}

		localClass.interfaces.push({
			t: finiteKeysMapInterface,
			params: [keyValueTypes.key.type, keyValueTypes.value.type]
		});

		return buildFields.concat(newFields);
	}

	static final finiteKeysMapInterface: Ref<ClassType> = {
		final interfaceString = "banker.finite.interfaces.FiniteKeysMap";
		final interfaceType = Context.getType(interfaceString).getClass();
		{
			get: function(): ClassType return interfaceType,
			toString: function(): String return interfaceString
		};
	}
}
#end
