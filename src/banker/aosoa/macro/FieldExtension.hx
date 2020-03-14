package banker.aosoa.macro;

#if macro
/**
	Functions for static extension used in `banker.aosoa.macro`.
**/
class FieldExtension {
	static final factoryMetadataName = ":banker.factory";

	/**
		@return The first found parameter of "@:banker.factory" metadata.
	**/
	public static function getFactory(_this: Field): Null<Expr> {
		final metadataArray = _this.meta;
		if (metadataArray == null) return null;

		for (i in 0...metadataArray.length) {
			final metadata = metadataArray[i];
			if (metadata.name != factoryMetadataName) continue;

			final parameters = metadata.params;
			if (parameters == null) continue;
			if (parameters.length == 0) continue;

			return parameters[0];
		}

		return null;
	}

	/**
		Overwrites the `kind` of `this` field with a variable type of `type`.
		@return `this` field.
	**/
	public static function setVariableType(_this: Field, type: ComplexType): Field {
		_this.kind = FVar(type);
		return _this;
	}

	/**
		Adds `access` to `this` field.
		@return `this` field.
	**/
	public static function addAccess(_this: Field, access: Access): Field {
		_this.access.push(access);
		return _this;
	}

	/**
		@return `true` if `this.name == "new"`.
	**/
	public static function isNew(_this: Field): Bool
		return _this.name == "new";
}
#end
