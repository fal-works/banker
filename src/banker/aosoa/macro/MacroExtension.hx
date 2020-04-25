package banker.aosoa.macro;

#if macro
class MacroExtension {
	/**
		@return `true` if `argument` is the special argument `chunkId`.
	**/
	public static function argumentIsChunkId(argument: FunctionArg): Bool {
		if (argument.name != "chunkId") return false;
		final complexType = argument.type;
		return complexType != null && complexType.toType().unify(Values.intType);
	}

	/**
		@return `true` if `argument` is the special argument `i`.
	**/
	public static function argumentIsWriteIndex(argument: FunctionArg): Bool {
		if (argument.name != "i") return false;
		final complexType = argument.type;
		return complexType != null && complexType.toType().unify(Values.intType);
	}

	/**
		@return `true` if `argument` is the special argument `disuse`.
	**/
	public static function argumentIsDisuse(argument: FunctionArg): Bool {
		if (argument.name != "disuse") return false;
		final complexType = argument.type;
		return complexType != null && complexType.toType().unify(Values.boolType);
	}
}
#end
