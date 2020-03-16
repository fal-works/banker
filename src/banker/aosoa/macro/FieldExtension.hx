package banker.aosoa.macro;

#if macro
import haxe.macro.Context;

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
		@return `true` if `this.name == "new"`.
	**/
	public static function isNew(_this: Field): Bool
		return _this.name == "new";
}
#end
