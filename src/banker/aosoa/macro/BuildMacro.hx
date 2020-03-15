package banker.aosoa.macro;

#if macro
using Lambda;

import haxe.macro.Context;

class BuildMacro {
	/**
		The entry point of build macro for `Structure` interface.
		Rebuilds the class as an AoSoA (Array of Structure of Arrays).
	**/
	public static function build(): Fields {
		debug("Start to build.");

		final localClass = Context.getLocalClass();
		if (localClass == null) {
			warn("Could not determine in which class the macro was called.");
			return null;
		}

		final localClassName = localClass.get().name;
		final position = Context.currentPos();

		final buildFields = Context.getBuildFields();
		final chunk = Chunk.create(
			buildFields,
			localClassName,
			position
		);

		final chunkType = MacroTools.defineSubTypes([chunk.typeDefinition])[0];
		debug('Created Chunk class: ${chunkType.pathString}');

		final aosoaClassName = localClassName + "Aosoa";
		final aosoaClass = Aosoa.create(
			aosoaClassName,
			chunk,
			chunkType.path,
			position
		);

		debug("End building.");
		return aosoaClass.fields;
	}
}
#end
