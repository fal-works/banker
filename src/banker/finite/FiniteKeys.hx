package banker.finite;

#if macro
using Lambda;
using sneaker.macro.MacroCaster;
using sneaker.macro.FieldExtension;
using sneaker.macro.EnumAbstractExtension;
using banker.array.ArrayFunctionalExtension;

import sneaker.macro.FieldExtension;
import sneaker.macro.PositionStack;
import sneaker.macro.ContextTools.getLocalClass;
import banker.array.ArrayTools;
import banker.finite.FiniteKeysValidator.*;

class FiniteKeys {
	/**
		Add fields to the class, generating from instances of `enumAbstractType`.
	**/
	public static macro function from(enumAbstractTypeExpression: Expr): Fields {
		PositionStack.reset();

		final localClassResult = getLocalClass();
		if (localClassResult.isFailedWarn()) return null;

		final localClass = localClassResult.unwrap();
		final metaAccess = localClass.meta;

		debug('Resolving enum abstract type.');
		final enumAbstractTypeResult = getEnumAbstractType(enumAbstractTypeExpression);
		if (enumAbstractTypeResult.isFailedWarn()) return null;
		final enumAbstractType = enumAbstractTypeResult.unwrap();
		debug("  Resolved: " + enumAbstractType.name);

		final buildFields = Context.getBuildFields();
		final instances = enumAbstractType.getInstances();

		debug('Determine initial values from metadata.');
		final initialValueResult = getInitialValue(buildFields, enumAbstractType);
		if (initialValueResult.isFailedWarn()) return null;
		final initialValue = initialValueResult.unwrap();
		debug('  Determined.');

		final valuesAreFinal = metaAccess.has('${MetadataName.finalValues}');

		debug('Create fields.');
		final fieldConverter = getFieldConverter(
			initialValue,
			valuesAreFinal,
			enumAbstractTypeExpression
		);

		final newFields = createFieldsWithGetters(instances, fieldConverter);
		for (field in newFields) debug('  - ${field.name}');
		if (localClass.constructor == null) {
			newFields.push(createConstructor());
			debug('  - new');
		}
		debug('  Created.');

		return buildFields.concat(newFields);
	}

	static function getFieldConverter(
		initialValue: InitialValue,
		valuesAreFinal: Bool,
		keyType: Expr
	): ClassField->Field {
		final fieldAccess = [APublic];
		if (valuesAreFinal) fieldAccess.push(AFinal);

		return switch initialValue {
			case Value(value, type):
				final fieldType:FieldType = FVar(type, value);
				function(instance): Field return {
					name: instance.name,
					kind: fieldType,
					pos: instance.pos,
					access: fieldAccess,
					doc: instance.doc
				}
			case Function(functionName, returnType):
				function(instance): Field return {
					final name = instance.name;
					return {
						name: name,
						kind: FVar(returnType, macro $i{functionName}($keyType.$name)),
						pos: instance.pos,
						access: fieldAccess,
						doc: instance.doc
					};
				}
		}
	}

	static function createGetter(instance: ClassField): Field {
		final name = instance.name;
		return {
			name: 'get$name',
			kind: FFun({
				args: [],
				ret: null,
				expr: macro return this.$name
			}),
			pos: instance.pos,
			access: [APublic, AInline]
		}
	}

	static function createFieldsWithGetters(
		instances: Array<ClassField>,
		fieldConverter: ClassField->Field
	): Fields {
		final newFields = ArrayTools.allocate(instances.length * 2);
		var writeIndex = 0;
		for (instance in instances) {
			newFields[writeIndex] = fieldConverter(instance);
			++writeIndex;
			newFields[writeIndex] = createGetter(instance);
			++writeIndex;
		}

		return newFields;
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
