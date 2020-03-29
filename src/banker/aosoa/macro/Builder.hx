package banker.aosoa.macro;

#if macro
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using banker.array.ArrayFunctionalExtension;

import haxe.macro.Context;
import sneaker.macro.ContextTools;
import sneaker.macro.ModuleTools;
import sneaker.macro.Types.Fields;
import sneaker.macro.extensions.FieldExtension;

class Builder {
	/**
		Stores fields of AoSoA classes generated in `build()`
		in order to copy to another class in `aosoaFrom()`.
	**/
	static final aosoaFieldsMap = new haxe.ds.StringMap<Fields>();

	/**
		The entry point of build macro for `Structure` interface.
		Rebuilds the class as an AoSoA (Array of Structure of Arrays).
	**/
	public static function build(): Fields {
		final localClassResult = ContextTools.getLocalClassRef();
		if (localClassResult.isFailedWarn()) return null;
		final localClassRef = localClassResult.unwrap();
		final localClass = localClassRef.get();

		setVerificationState(localClass);
		if (notVerified) debug("Start to build.");

		final localClassName = localClass.name;
		final position = Context.currentPos();
		final buildFields = Context.getBuildFields();

		final buildFieldClones = buildFields.map(FieldExtension.clone);
		// buildFieldClones.forEach(field -> field.pos = position);

		final chunk = Chunk.create(buildFieldClones, localClassName, position);
		final chunkType = ModuleTools.defineSubTypes([chunk.typeDefinition])[0];
		if (notVerified) debug('Created Chunk class: ${chunkType.pathString}');

		final aosoaClass = Aosoa.create(localClassName, chunk, chunkType, position);
		aosoaFieldsMap.set(localClassRef.toString(), aosoaClass.fields);
		if (notVerified) debug('Registered AoSoA fields.');

		if (localClass.meta.has(MetadataNames.doNotDefineAosoa)) {
			debug('Found metadata: @${MetadataNames.doNotDefineAosoa}');
			debug('End building.');
			return null;
		}

		final aosoaType = ModuleTools.defineSubTypes([aosoaClass])[0];
		if (notVerified) debug('Defined AoSoA class: ${aosoaType.pathString}');

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

	/**

		@param structureType
		@return Fields
	**/
	public static macro function aosoaFrom(structureTypeExpression: Expr): Fields {
		final localClassResult = ContextTools.getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();

		setVerificationState(localClass);
		if (notVerified) debug("Start to build.");

		final structureTypeString = structureTypeExpression.toString();
		final position = structureTypeExpression.pos;

		final structureType = ContextTools.tryGetType(structureTypeString);
		if (structureType == null) {
			warn('Type not found: $structureTypeString', position);
			return null;
		}

		if (notVerified) debug('Resolving class: $structureTypeString');

		try {
			var classType = structureType.getClass();
			var foundInterface = false;
			while (classType != null) {
				foundInterface = classType.interfaces.hasAny(ref -> ref.t.get().module == "banker.aosoa.Structure");
				final superClassRef = classType.superClass;
				classType = if (superClassRef != null) superClassRef.t.get(); else null;
			}
			if (!foundInterface) {
				warn(
					'Required a class implementing `banker.aosoa.Structure` interface',
					position
				);
			}
		} catch (_:Dynamic) {
			warn('Failed to resolve type as a class: $structureTypeString', position);
			return null;
		}

		setVerificationState(localClass); // Set again as the state may be changed

		if (notVerified) {
			debug('Resolved class: $structureTypeString');
			debug('Add AoSoA fields generated from: $structureTypeString');
		}

		final aosoaFields = aosoaFieldsMap.get(structureTypeString);
		if (aosoaFields == null) {
			warn(
				'Failed to get AoSoA fields ... Try restarting completion server.',
				position
			);
			return null;
		}

		if (notVerified) debug("End building.");

		return Context.getBuildFields().concat(aosoaFields);
	}
}
#end
