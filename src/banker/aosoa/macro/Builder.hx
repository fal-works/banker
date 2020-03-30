package banker.aosoa.macro;

#if macro
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using sneaker.macro.MacroCaster;
using sneaker.macro.extensions.ClassTypeExtension;
using sneaker.macro.extensions.TypeExtension;
using banker.array.ArrayExtension;
using banker.array.ArrayFunctionalExtension;

import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Type;
import sneaker.macro.ContextTools;
import sneaker.macro.ModuleTools;
import sneaker.macro.Types.Fields;
import sneaker.macro.extensions.FieldExtension;

class Builder {
	/**
		Mapping from class names (`Structure` classes and their super-classes) to their fields.
		Used for processing inherited fields in `build()`.
	**/
	@:isVar static var buildFieldsMap(get, null): StringMap<Fields>;

	static function get_buildFieldsMap() {
		if (buildFieldsMap == null) buildFieldsMap = new StringMap<Fields>();
		return buildFieldsMap;
	}

	/**
		Mapping from `Structure` class names to AoSoA class fields generated in `build()`.
		Used for copying fields to another class in `aosoaFrom()`.
	**/
	@:isVar static var aosoaFieldsMap(get, null): StringMap<Fields>;

	static function get_aosoaFieldsMap() {
		if (aosoaFieldsMap == null) aosoaFieldsMap = new StringMap<Fields>();
		return aosoaFieldsMap;
	}

	/**
		The entry point of build macro for `Structure` interface.
		Rebuilds the class as an AoSoA (Array of Structure of Arrays).
	**/
	public static function build(): Fields {
		final localClassResult = ContextTools.getLocalClassRef();
		if (localClassResult.isFailedWarn()) return null;
		final localClassRef = localClassResult.unwrap();
		final localClass = localClassRef.get();
		final localClassPathString = localClassRef.toString();
		if (buildFieldsMap.get(localClassPathString) != null) return null; // already built

		setVerificationState(localClass);
		if (notVerified) debug("Start to build.");

		final buildFields = Context.getBuildFields();
		final buildFieldsCopy = buildFields.copy();
		buildFieldsMap.set(localClassRef.toString(), buildFieldsCopy);

		final localMeta = localClass.meta;
		if (localMeta.has(MetadataNames.doNotBuild) || localMeta.has(MetadataNames.doNotBuild_)) {
			if (notVerified) {
				debug('Found metadata: ${MetadataNames.doNotBuild}');
				debug('End building.');
			}
			return null;
		}

		final allFields = getAllFields(localClassRef, buildFieldsCopy);
		final buildFieldClones = allFields.map(FieldExtension.clone);
		// buildFieldClones.forEach(field -> field.pos = position);

		final localClassName = localClass.name;
		final position = Context.currentPos();

		final chunk = Chunk.create(buildFieldClones, localClassName, position);
		final chunkType = ModuleTools.defineSubTypes([chunk.typeDefinition])[0];
		if (notVerified) debug('Created Chunk class: ${chunkType.pathString}');

		final aosoaClass = Aosoa.create(localClassName, chunk, chunkType, position);
		aosoaFieldsMap.set(localClassPathString, aosoaClass.fields);
		if (notVerified) debug('Registered AoSoA fields.');

		if (localMeta.has(MetadataNames.doNotDefineAosoa) || localMeta.has(MetadataNames.doNotDefineAosoa_)) {
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
		@return All fields including `buildFields` and fields of super-classes.
	**/
	static function getAllFields(localClassRef: Ref<ClassType>, buildFields: Fields): Fields {
		final fieldArrays: Array<Fields> = [buildFields];
		var currentClass: Null<ClassType> = localClassRef.get();

		while (true) {
			final superClass = currentClass.superClass;
			if (superClass == null) break;

			final superClassPath = superClass.t.toString();
			final fields = buildFieldsMap.get(superClassPath);
			if (fields == null) {
				warn('Failed to get fields of $superClassPath ... Try restarting completion server.');
				break;
			}
			fieldArrays.push(fields);

			currentClass = superClass.t.get();
		}

		fieldArrays.reverse();
		return fieldArrays.flatten();
	}

	/**
		The entry point of build macro for copying AoSoA fields generated from another `Structure` type.
		@param structureTypeExpression Any class that implements `banker.aosoa.Structure` interface.
	**/
	public static macro function aosoaFrom(structureTypeExpression: Expr): Null<Fields> {
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

		final maybeClassType = structureType.toClassType();
		if (maybeClassType.isNone()) {
			warn('Failed to resolve type as a class', position);
			return null;
		}
		final classType = maybeClassType.unwrap();

		if (!classType.implementsInterface("banker.aosoa.Structure")) {
			warn(
				'Required a class implementing `banker.aosoa.Structure` interface',
				position
			);
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
