package banker.finite;

#if macro
import haxe.macro.Expr;
import banker.array.ArrayTools;

class FiniteKeysMap {
	public static function createFieldsWithGetter(
		instances: Array<ClassField>,
		fieldConverter: ClassField->Field,
		keyType: Expr
	): Fields {
		final newFields = ArrayTools.allocate(instances.length * 2 + 1);
		var writeIndex = 0;

		for (instance in instances) {
			newFields[writeIndex] = fieldConverter(instance);
			++writeIndex;
			newFields[writeIndex] = createGetter(instance);
			++writeIndex;
		}

		newFields[writeIndex] = createGeneralGetter(instances, keyType);

		return newFields;
	}

	public static function createFieldsWithGetterSetter(
		instances: Array<ClassField>,
		fieldConverter: ClassField->Field,
		keyType: Expr
	): Fields {
		final newFields = ArrayTools.allocate(instances.length * 3 + 1);
		var writeIndex = 0;

		for (instance in instances) {
			newFields[writeIndex] = fieldConverter(instance);
			++writeIndex;
			newFields[writeIndex] = createGetter(instance);
			++writeIndex;
			newFields[writeIndex] = createSetter(instance);
			++writeIndex;
		}

		newFields[writeIndex] = createGeneralGetter(instances, keyType);
		++writeIndex;
		newFields[writeIndex] = createGeneralSetter(instances,keyType);

		return newFields;
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

	static function createGeneralGetter(instances: Array<ClassField>, keyType: Expr): Field {
		final cases: Array<Case> = [
			for (instance in instances) {
				final name = instance.name;
				{
					values: [macro $keyType.$name],
					expr: macro this.$name
				};
			}
		];
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
			name: "get",
			kind: fieldType,
			pos: Context.currentPos(),
			access: [APublic, AInline]
		};
	}

	static function createSetter(instance: ClassField): Field {
		final name = instance.name;
		return {
			name: 'set$name',
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

	static function createGeneralSetter(instances: Array<ClassField>, keyType: Expr): Field {
		final cases: Array<Case> = [
			for (instance in instances) {
				final name = instance.name;
				{
					values: [macro $keyType.$name],
					expr: macro this.$name = value
				};
			}
		];
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
			name: "set",
			kind: fieldType,
			pos: Context.currentPos(),
			access: [APublic, AInline]
		};
	}
}
#end
