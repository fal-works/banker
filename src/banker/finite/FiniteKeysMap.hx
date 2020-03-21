package banker.finite;

#if macro
import haxe.macro.Expr;
import banker.array.ArrayTools;

class FiniteKeysMap {
	public static function createFieldsWithGetter(
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
			newFields[writeIndex] = createGetter(instance, getterName);
			++writeIndex;
		}

		newFields[writeIndex] = createGeneralGetter(instances, keyType, getterName);

		return newFields;
	}

	public static function createFieldsWithGetterSetter(
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
			newFields[writeIndex] = createGetter(instance, getterName);
			++writeIndex;
			newFields[writeIndex] = createSetter(instance, setterName);
			++writeIndex;
		}

		newFields[writeIndex] = createGeneralGetter(instances, keyType, getterName);
		++writeIndex;
		newFields[writeIndex] = createGeneralSetter(instances, keyType, setterName);

		return newFields;
	}

	static function createGetter(instance: ClassField, prefix: String): Field {
		final name = instance.name;
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

	static function createGeneralGetter(
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

	static function createSetter(instance: ClassField, prefix: String): Field {
		final name = instance.name;
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

	static function createGeneralSetter(
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
