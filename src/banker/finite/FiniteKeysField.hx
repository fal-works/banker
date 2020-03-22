package banker.finite;

#if macro
/**
	Common functions for `FiniteKeys` macro.
**/
class FiniteKeysField {
	/**
		@return Function that converts an enum abstract instance to an initialized variable field.
	**/
	public static function getFieldConverter(
		initialValue: InitialValue,
		valuesAreFinal: Bool,
		keyType: Expr
	): ClassField->Field {
		final fieldAccess: Array<Access> = [APublic];
		if (valuesAreFinal) fieldAccess.push(AFinal);

		return switch (initialValue.kind) {
			case Value(value):
				final fieldType:FieldType = FVar(initialValue.type, value);
				function(instance): Field return {
					name: instance.name,
					kind: fieldType,
					pos: instance.pos,
					access: fieldAccess,
					doc: instance.doc
				}
			case Function(functionName):
				function(instance): Field return {
					final name = instance.name;
					return {
						name: name,
						kind: FVar(
							initialValue.type,
							macro $i{functionName}($keyType.$name)
						),
						pos: instance.pos,
						access: fieldAccess,
						doc: instance.doc
					};
				}
		}
	}

	/**
		@return An empty public function field with name "new".
	**/
	public static function createConstructor(): Field {
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
