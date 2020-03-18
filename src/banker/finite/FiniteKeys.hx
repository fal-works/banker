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
	public static macro function from(enumAbstractType: Expr): Fields {
		PositionStack.reset();

		final localClassResult = catchLocalClass.run(null);
		if (localClassResult.failed) return null;

		final localClass = localClassResult.unwrap();
		final metaAccess = localClass.meta;

		debug('Resolving enum abstract type.');
		final enumAbstractTypeResolved = catchEnumAbstractType.run(enumAbstractType);
		if (enumAbstractTypeResolved.failed) return null;
		debug("  Resolved: " + enumAbstractTypeResolved.unwrap().name);

		final instances = enumAbstractTypeResolved.unwrap().getInstances();

		debug('Determine default value from metadata.');
		final defaultValueResult = catchDefaultValue.run(metaAccess);
		if (defaultValueResult.failed) return null;
		final defaultValue = defaultValueResult.unwrap();
		debug('  Determined.');

		final buildFields = Context.getBuildFields();

		debug('Create fields.');
		final newFields = createFields(
			instances,
			defaultValue,
			metaAccess.has(':banker.finite.final')
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
		defaultValue: DefaultValue,
		valuesAreFinal: Bool
	): Fields {
		final fieldAccess = [APublic];
		if (valuesAreFinal) fieldAccess.push(AFinal);

		return switch defaultValue {
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
