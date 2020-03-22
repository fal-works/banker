package banker.aosoa.macro;

#if macro
using banker.array.ArrayFunctionalExtension;

import haxe.macro.Context;
import sneaker.macro.ContextTools;
import sneaker.macro.ModuleTools;
import sneaker.macro.Types.Fields;
import sneaker.macro.extensions.FieldExtension;

class BuildMacro {
	/**
		The entry point of build macro for `Structure` interface.
		Rebuilds the class as an AoSoA (Array of Structure of Arrays).
	**/
	public static function build(): Fields {
		final localClassResult = ContextTools.getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();

		setVerificationState(localClass);
		if (notVerified) debug("Start to build.");

		final localClassName = localClass.name;
		final position = Context.currentPos();
		final buildFields = Context.getBuildFields();

		final buildFieldClones = buildFields.map(FieldExtension.clone);
		buildFieldClones.forEach(field -> field.pos = position);

		final chunk = Chunk.create(buildFieldClones, localClassName, position);
		final chunkType = ModuleTools.defineSubTypes([chunk.typeDefinition])[0];
		if (notVerified) debug('Created Chunk class: ${chunkType.pathString}');

		final aosoaClass = Aosoa.create(localClassName, chunk, chunkType, position);
		final aosoaType = ModuleTools.defineSubTypes([aosoaClass])[0];
		if (notVerified) debug('Created Aosoa class: ${aosoaType.pathString}');

		final createAosoaMethod = Aosoa.createAosoaCreatorMethod(
			aosoaType,
			position
		);
		buildFields.push(createAosoaMethod);

		if (notVerified) {
			debug('Added method: $localClassName::createAosoa()');
			debug("End building.");
		}

		return buildFields;
	}
}
#end
