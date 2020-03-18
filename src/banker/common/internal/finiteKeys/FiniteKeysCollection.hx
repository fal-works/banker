package banker.common.internal.finiteKeys;

#if macro
using sneaker.macro.MacroCaster;
using sneaker.macro.FieldExtension;
using sneaker.macro.EnumAbstractExtension;
using banker.array.ArrayFunctionalExtension;

import sneaker.macro.MacroLogger.*;
import sneaker.macro.FieldExtension;
import sneaker.macro.PositionStack;
import banker.common.internal.finiteKeys.FiniteKeysCollectionValidator.*;

/**
	Build macro for `FiniteKeysSet`.
**/
class FiniteKeysCollection {
	/**
		Add fields to the class.
		Fields are generated from instances of an enum abstract given by metadata.
	**/
	public static function build(): Fields {
		final localClassResult = catchLocalClass.run(null);
		if (localClassResult.failed) return null;

		final localClass = localClassResult.unwrap();
		final metaAccess = localClass.meta;

		debug("Resolving @:banker.finiteKeys.enumAbstract metadata.");
		final enumAbstractParameter = catchEnumAbstractParameter.run(metaAccess);
		if (enumAbstractParameter.failed) return null;

		final enumAbstractType = catchEnumAbstractType.run(enumAbstractParameter.unwrap());
		if (enumAbstractType.failed) return null;

		debug("  Resolved: " + enumAbstractType.unwrap().name);
		final instances = enumAbstractType.unwrap().getInstances();

		var valueType: ComplexType;
		var defaultValue: DefaultValue;

		if (localClass.params.length == 0) {
			valueType = (macro:Bool);
			defaultValue = Value(macro false);
		} else {
			valueType = localClass.params[0].typeParameterToComplexType();

			final defaultValueResult = catchDefaultValue.run(metaAccess);
			if (defaultValueResult.failed) return null;

			defaultValue = defaultValueResult.unwrap();
		}

		final buildFields = Context.getBuildFields();

		debug('Create fields.');
		final newFields = createFields(
			instances,
			defaultValue,
			valueType,
			metaAccess.has(':banker.finiteKeys.final')
		);
		for (field in newFields) debug('  - ${field.name}');
		if (!buildFields.hasAny(FieldExtension.isNew)) {
			newFields.push(createConstructor());
			debug('  - new');
		}
		debug('  Created.');

		return buildFields.concat(newFields);
	}

	static function createFields(
		instances: Array<ClassField>,
		defaultValue: DefaultValue,
		valueType: ComplexType,
		valuesAreFinal: Bool
	): Fields {
		final fieldAccess = [APublic];
		if (valuesAreFinal) fieldAccess.push(AFinal);

		return switch defaultValue {
			case Value(val):
				final fieldType:FieldType = FVar(valueType, val);
				instances.map(function(instance): Field return {
					name: instance.name,
					kind: fieldType,
					pos: instance.pos,
					access: fieldAccess,
					doc: instance.doc
				});
			case Function(factory):
				instances.map(function(instance): Field return {
					name: instance.name,
					kind: FVar(valueType, macro factory()),
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
			pos: PositionStack.calledPosition
		};
	}
}
#end
