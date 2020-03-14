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

		final buildFields = Context.getBuildFields();
		final chunk = Chunk.create(
			buildFields,
			localClass.get().name,
			Context.currentPos()
		);

		final chunkType = Chunk.define(chunk.typeDefinition);
		debug('Created Chunk class: ${chunkType.pathString}');

		final buildConstructor = buildFields.find(FieldExtension.isNew);

		final aosoaFields = Aosoa.create(
			chunk,
			chunkType.path,
			Context.currentPos(),
			if (buildConstructor != null) buildConstructor.pos else null
		);

		debug("End building.");
		return aosoaFields;
	}
}
#end
