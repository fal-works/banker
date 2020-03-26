package banker.aosoa.macro;

#if macro
import haxe.macro.Context;

/**
	Functions for static extension used in `banker.aosoa.macro`.
**/
class FieldExtension {
	/**
		@return The first found parameter of "@:banker.factory" metadata.
	**/
	public static function getFactory(_this: Field): Null<Expr> {
		final metadataArray = _this.meta;
		if (metadataArray == null) return null;

		for (i in 0...metadataArray.length) {
			final metadata = metadataArray[i];
			if (metadata.name != MetadataNames.factory) continue;

			final parameters = metadata.params;
			if (parameters == null) continue;
			if (parameters.length == 0) continue;

			return parameters[0];
		}

		return null;
	}
}
#end
