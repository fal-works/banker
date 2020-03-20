package banker.finite;

#if macro
using sneaker.macro.MacroCaster;
using sneaker.macro.FieldExtension;
using sneaker.macro.EnumAbstractExtension;
using banker.array.ArrayFunctionalExtension;

import sneaker.macro.FieldExtension;
import sneaker.macro.PositionStack;
import banker.finite.FiniteKeysValidator.*;

class FiniteKeys {
	/**
		Add fields to the class, generating from instances of `enumAbstractType`.
	**/
	public static macro function from(enumAbstractTypeExpression: Expr): Fields {
		PositionStack.reset();

		final localClassResult = catchLocalClass.run(null);
		if (localClassResult.failed) return null;

		final localClass = localClassResult.unwrap();
		final metaAccess = localClass.meta;

		debug('Resolving enum abstract type.');
		final enumAbstractTypeResult = catchEnumAbstractType.run(enumAbstractTypeExpression);
		if (enumAbstractTypeResult.failed) return null;
		final enumAbstractType = enumAbstractTypeResult.unwrap();
		debug("  Resolved: " + enumAbstractType.name);

		final instances = enumAbstractType.getInstances();

		debug('Determine initial values from metadata.');
		final initialValueResult = catchInitialValue.run(metaAccess);
		if (initialValueResult.failed) return null;
		final initialValue = initialValueResult.unwrap();
		debug('  Determined.');

		final buildFields = Context.getBuildFields();
		final valuesAreFinal = metaAccess.has('${MetadataName.finalValues}');

		debug('Create fields.');
		final newFields = createFields(
			instances,
			initialValue,
			valuesAreFinal
		);
		for (field in newFields) debug('  - ${field.name}');
		if (localClass.constructor == null) {
			newFields.push(createConstructor());
			debug('  - new');
		}
		debug('  Created.');

		return buildFields.concat(newFields);
	}

	static function createFields(
		instances: Array<ClassField>,
		initialValue: InitialValue,
		valuesAreFinal: Bool
	): Fields {
		final fieldAccess = [APublic];
		if (valuesAreFinal) fieldAccess.push(AFinal);

		return switch initialValue {
			case Value(value, type):
				final fieldType:FieldType = FVar(type, value);
				instances.map(function(instance): Field return {
					name: instance.name,
					kind: fieldType,
					pos: instance.pos,
					access: fieldAccess,
					doc: instance.doc
				});
			case Function(factory, returnType):
				instances.map(function(instance): Field return {
					name: instance.name,
					kind: FVar(returnType, macro factory()),
					pos: instance.pos,
					access: fieldAccess,
					doc: instance.doc
				});
		}
	}

	static function createConstructor(): Field {
		return {
			name: "new",
			kind: FFun({
				args: [],
				ret: null,
				expr: macro null
			}),
			access: [APublic],
			pos: Context.currentPos()
		};
	}
}
#end
