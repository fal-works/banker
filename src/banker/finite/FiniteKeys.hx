package banker.finite;

#if macro
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
		debug('Start to build.');

		final localClassResult = getLocalClass();
		if (localClassResult.isFailedWarn()) return null;

		final localClass = localClassResult.unwrap();
		final metaAccess = localClass.meta;

		debug('Resolving enum abstract type.');
		final enumAbstractTypeResult = getEnumAbstractType(keyTypeExpression);
		if (enumAbstractTypeResult.isFailedWarn()) return null;
		final enumAbstractType = enumAbstractTypeResult.unwrap();
		debug("  Resolved: " + enumAbstractType.name);

		final buildFields = Context.getBuildFields();
		final instances = enumAbstractType.getInstances();

		debug('Determine initial values from metadata.');
		final initialValueResult = getInitialValue(
			buildFields,
			enumAbstractType.name
		);
		if (initialValueResult.isFailedWarn()) return null;
		final initialValue = initialValueResult.unwrap();
		debug('  Determined.');

		final valuesAreFinal = metaAccess.has('${MetadataName.finalValues}');
		if (valuesAreFinal) {
			debug('Found metadata: @${MetadataName.finalValues}');
			debug('Create read-only fields.');
		} else {
			debug('Metadata not specified: @${MetadataName.finalValues}');
			debug('Create writable fields.');
		}

		final fieldConverter = FiniteKeysField.getFieldConverter(
			initialValue,
			valuesAreFinal,
			keyTypeExpression
		);

		final newFields = if (valuesAreFinal)
			FiniteKeysMap.createReadOnlyFields(
				instances,
				fieldConverter,
				keyTypeExpression
			);
		else
			FiniteKeysMap.createWritableFields(
				instances,
				fieldConverter,
				keyTypeExpression
			);

		final keyComplexType = enumAbstractType.toComplexType2();
		final sequenceFields = FiniteKeysSequence.createSequenceMethods(
			instances,
			keyTypeExpression,
			keyComplexType,
			initialValue.type
		);
		newFields.pushFromArray(sequenceFields);

		if (localClass.constructor == null)
			newFields.push(FiniteKeysField.createConstructor());

		for (field in newFields) debug('  - ${field.name}');
		debug('  Created.');

		debug('End building.');
		return buildFields.concat(newFields);
	}
}
#end
