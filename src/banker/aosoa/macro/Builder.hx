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
import sneaker.types.Maybe;
import sneaker.macro.ContextTools;
import sneaker.macro.ModuleTools;
import sneaker.macro.Types.Fields;
import sneaker.macro.extensions.FieldExtension;

class Builder {
	/**
		The entry point of build macro for `Structure` interface.
		Registers fields and a Chunk builder function.
	**/
	public static function structure(): Fields {
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
		buildFieldsMap.set(localClassPathString, buildFieldsCopy);

		final allFields = getAllFields(localClassRef, buildFieldsCopy);
		final buildFieldClones = allFields.map(FieldExtension.clone);
		// buildFieldClones.forEach(field -> field.pos = position);

		final localClassName = localClass.name;
		final position = Context.currentPos();

		final chunkBuilder = Chunk.create.bind(_, buildFieldClones, position);
		chunkBuilderMap.set(localClassPathString, chunkBuilder);
		if (notVerified) {
			debug('Registered Chunk builder for: $localClassPathString');
			debug('End building.');
		}

		return null;
	}

	/**
		Adds Chunk fields to the local class and registeres an AoSoA builder function.
		Called from `banker.aosoa.Chunk.fromStructure()`.
		@param structureTypeExpression Any `Structure` class.
	**/
	public static function chunkFromStructure(
		structureTypeExpression: Expr
	): Null<Fields> {
		final prepared = prepareFrom(structureTypeExpression, true);
		if (prepared.isNone()) return null;
		final localClassRef = prepared.unwrap().localClassRef;
		final localClass = localClassRef.get();
		final localClassPathString = localClassRef.toString();
		final localClassPathStringFull = '${localClass.module}.${localClass.name}';
		final chunkTypeString = prepared.unwrap().sourceTypeString;

		final chunkBuilder = chunkBuilderMap.get(chunkTypeString);
		if (chunkBuilder == null) {
			warn(
				'Failed to get Chunk definition ... Try restarting completion server.',
				structureTypeExpression.pos
			);
			return null;
		}

		if (notVerified) debug('Create Chunk fields.');
		final chunk = chunkBuilder(localClass.name);
		if (notVerified) debug('Created all fields.');

		final aosoaClassBuilder = Aosoa.create.bind(
			_,
			localClassPathStringFull,
			chunk,
			localClass
		);
		aosoaBuilderMap.set(localClassPathString, aosoaClassBuilder);
		if (notVerified) debug('Registered AoSoA builder for: $localClassPathString');

		if (notVerified) debug("End building.");
		return Context.getBuildFields().concat(chunk.typeDefinition.fields);
	}

	/**
		Adds AoSoA fields to the local class.
		Called from `banker.aosoa.Aosoa.fromChunk()`.
		@param chunkTypeExpression Any Chunk class.
	**/
	public static function aosoaFromChunk(chunkTypeExpression: Expr): Null<Fields> {
		final prepared = prepareFrom(chunkTypeExpression, false);
		if (prepared.isNone()) return null;
		final localClassRef = prepared.unwrap().localClassRef;
		final localClass = localClassRef.get();
		final chunkTypeString = prepared.unwrap().sourceTypeString;

		final aosoaBuilder = aosoaBuilderMap.get(chunkTypeString);
		if (aosoaBuilder == null) {
			warn(
				'Failed to get AoSoA builder ... Try restarting completion server.',
				chunkTypeExpression.pos
			);
			return null;
		}
		if (notVerified) debug('Create AoSoA fields.');
		final aosoaClass = aosoaBuilder(localClass.name);
		if (notVerified) debug('Created all fields.');

		if (notVerified) debug("End building.");
		return Context.getBuildFields().concat(aosoaClass.fields);
	}

	/**
		Mapping from class names (`Structure` classes and their super-classes) to their fields.
		Used for processing inherited fields in `structure()`.
	**/
	@:isVar static var buildFieldsMap(get, null): StringMap<Fields>;

	/**
		Mapping from `Structure` class names to Chunk builder functions.
		Used for building a Chunk class in `chunkFromStructure()`.
	**/
	@:isVar static var chunkBuilderMap(
		get,
		null
	): StringMap<(chunkName: String) -> ChunkDefinition>;

	/**
		Mapping from Chunk class names to AoSoA builder functions.
		Used for building an AoSoA class in `aosoaFromChunk()`.
	**/
	@:isVar static var aosoaBuilderMap(
		get,
		null
	): StringMap<(aosoaName: String) -> TypeDefinition>;

	/**
		@return All fields including `buildFields` and fields of super-classes.
	**/
	static function getAllFields(
		localClassRef: Ref<ClassType>,
		buildFields: Fields
	): Fields {
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
		Resolves `sourceTypeExpression`.
		Internally used in `chunkFromStructure()` and `aosoaFromChunk()`.
		@param sourceTypeExpression Any class that is either a `Structure` or a Chunk.
		@param checkStructureInterface `true` for checking that the source type implements `Structure`.
		@return Local class in `Maybe` representation.
	**/
	static function prepareFrom(
		sourceTypeExpression: Expr,
		checkStructureInterface: Bool
	): Maybe<{localClassRef: Ref<ClassType>, sourceTypeString: String }> {
		final localClassResult = ContextTools.getLocalClassRef();
		if (localClassResult.isFailedWarn()) return null;
		final localClassRef = localClassResult.unwrap();
		final localClass = localClassRef.get();

		setVerificationState(localClass);
		if (notVerified) debug("Start to build.");

		final sourceTypeString = sourceTypeExpression.toString();
		final position = sourceTypeExpression.pos;

		final sourceType = ContextTools.tryGetType(sourceTypeString);
		if (sourceType == null) {
			warn('Type not found: $sourceTypeString', position);
			return null;
		}

		if (notVerified) debug('Resolving class: $sourceTypeString');

		final maybeSourceClass = sourceType.toClassType();
		if (maybeSourceClass.isNone()) {
			warn('Failed to resolve type as a class', position);
			return null;
		}

		final sourceClass = maybeSourceClass.unwrap();
		if (checkStructureInterface) {
			if (!sourceClass.implementsInterface("banker.aosoa.Structure")) {
				warn(
					'Required a class implementing `banker.aosoa.Structure` interface',
					position
				);
				return null;
			}
		}

		setVerificationState(localClass); // Set again as the state may be changed

		if (notVerified) debug('Resolved class: $sourceTypeString');

		return {
			localClassRef: localClassRef,
			sourceTypeString: sourceType.toString()
		};
	}

	static function get_buildFieldsMap() {
		if (buildFieldsMap == null) buildFieldsMap = new StringMap();
		return buildFieldsMap;
	}

	static function get_chunkBuilderMap() {
		if (chunkBuilderMap == null) chunkBuilderMap = new StringMap();
		return chunkBuilderMap;
	}

	static function get_aosoaBuilderMap() {
		if (aosoaBuilderMap == null) aosoaBuilderMap = new StringMap();
		return aosoaBuilderMap;
	}
}
#end
