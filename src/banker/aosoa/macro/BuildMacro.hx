package banker.aosoa.macro;

#if macro
using banker.array.ArrayFunctionalExtension;

import haxe.macro.Context;
import sneaker.macro.FieldExtension;
import sneaker.macro.ModuleTools;
import sneaker.macro.Types.Fields;

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

		final buildFieldClones = buildFields.map(FieldExtension.clone);
		buildFieldClones.forEach(field -> field.pos = position);

		final chunk = Chunk.create(
			buildFieldClones,
			localClassName,
			position
		);
		final chunkType = ModuleTools.defineSubTypes([chunk.typeDefinition])[0];
		debug('Created Chunk class: ${chunkType.pathString}');

		final aosoaClass = Aosoa.create(
			localClassName,
			chunk,
			chunkType,
			position
		);
		final aosoaType = ModuleTools.defineSubTypes([aosoaClass])[0];
		debug('Created Aosoa class: ${aosoaType.pathString}');

		final createAosoaMethod = Aosoa.createAosoaCreatorMethod(aosoaType, position);
		buildFields.push(createAosoaMethod);
		debug('Added method: $localClassName::createAosoa()');

		debug("End building.");
		return buildFields;
	}
}
#end
