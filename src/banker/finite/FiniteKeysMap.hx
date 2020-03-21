package banker.finite;

#if macro
using sneaker.format.StringExtension;

import haxe.macro.Expr;
import banker.array.ArrayTools;

class FiniteKeysMap {
	public static function createReadOnlyFields(
		instances: Array<ClassField>,
		fieldConverter: ClassField->Field,
		keyType: Expr,
		getterName: String
	): Fields {
		final newFields = ArrayTools.allocate(instances.length * 2 + 1);
		var writeIndex = 0;

		for (instance in instances) {
			newFields[writeIndex] = fieldConverter(instance);
			++writeIndex;
			newFields[writeIndex] = createGet(instance, getterName);
			++writeIndex;
		}

		newFields[writeIndex] = createGeneralGet(instances, keyType, getterName);

		return newFields;
	}

	public static function createWritableFields(
		instances: Array<ClassField>,
		fieldConverter: ClassField->Field,
		keyType: Expr,
		getterName: String,
		setterName: String
	): Fields {
		final newFields = ArrayTools.allocate(instances.length * 3 + 1);
		var writeIndex = 0;

		for (instance in instances) {
			newFields[writeIndex] = fieldConverter(instance);
			++writeIndex;
			newFields[writeIndex] = createGet(instance, getterName);
			++writeIndex;
			newFields[writeIndex] = createSet(instance, setterName);
			++writeIndex;
		}

		newFields[writeIndex] = createGeneralGet(instances, keyType, getterName);
		++writeIndex;
		newFields[writeIndex] = createGeneralSet(instances, keyType, setterName);

		return newFields;
	}

	static function createGet(instance: ClassField, prefix: String): Field {
		final name = instance.name.camelToPascal();
		return {
			name: '$prefix$name',
			kind: FFun({
				args: [],
				ret: null,
				expr: macro return this.$name
			}),
			pos: instance.pos,
			access: [APublic, AInline]
		}
	}

	static function createGeneralGet(
		instances: Array<ClassField>,
		keyType: Expr,
		methodName: String
	): Field {
		final cases: Array<Case> = [for (instance in instances) {
			final name = instance.name;
			{
				values: [macro $keyType.$name],
				expr: macro this.$name
			};
		}];
		final switchExpression: Expr = {
			expr: ESwitch(macro key, cases, null),
			pos: Context.currentPos()
		};
		final fieldType: FieldType = FFun({
			args: [{
				name: "key",
				type: null
			}],
			ret: null,
			expr: macro return $switchExpression
		});

		return {
			name: methodName,
			kind: fieldType,
			pos: Context.currentPos(),
			access: [APublic, AInline]
		};
	}

	static function createSet(instance: ClassField, prefix: String): Field {
		final name = instance.name.camelToPascal();
		return {
			name: '$prefix$name',
			kind: FFun({
				args: [{
					name: "value",
					type: null
				}],
				ret: null,
				expr: macro return this.$name = value
			}),
			pos: instance.pos,
			access: [APublic, AInline]
		}
	}

	static function createGeneralSet(
		instances: Array<ClassField>,
		keyType: Expr,
		methodName: String
	): Field {
		final cases: Array<Case> = [for (instance in instances) {
			final name = instance.name;
			{
				values: [macro $keyType.$name],
				expr: macro this.$name = value
			};
		}];
		final switchExpression: Expr = {
			expr: ESwitch(macro key, cases, null),
			pos: Context.currentPos()
		};
		final fieldType: FieldType = FFun({
			args: [{
				name: "key",
				type: null
			}, {
				name: "value",
				type: null
			}],
			ret: null,
			expr: macro return $switchExpression
		});

		return {
			name: methodName,
			kind: fieldType,
			pos: Context.currentPos(),
			access: [APublic, AInline]
		};
	}
}
#end
