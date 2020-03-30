package banker.aosoa.macro;

#if macro
using sneaker.macro.extensions.FieldExtension;
using sneaker.macro.MacroComparator;
using banker.array.ArrayExtension;
using banker.aosoa.macro.FieldExtension;
using banker.aosoa.macro.MacroExtension;

import sneaker.macro.Types;
import sneaker.macro.MacroComparator.unifyComplex;
import banker.aosoa.macro.ChunkMethodBuilder.*;
import banker.aosoa.macro.ChunkVariableBuilder.*;

class Chunk {
	/**
		Creates a new Chunk class.
	**/
	public static function create(
		buildFields: Array<Field>,
		structureName: String,
		position: Position
	): ChunkDefinition {
		final chunkClassName = structureName + "Chunk";
		final prepared = prepare(chunkClassName, buildFields);
		final variables = prepared.variables;

		final chunkClass: TypeDefinition = macro class $chunkClassName {
			/**
				The largest index of entities that are currently in use.
				The chunk iterates until (but not including) this index when iterating entities.
			**/
			public var endReadIndex(default, null) = 0;

			/**
				The first index of entities that are currently not in use.
				The chunk uses this index when using a new entity.
			**/
			public var nextWriteIndex(default, null) = 0;

			/**
				Table that maps the indices between the main vector and the WRITE-buffer vector.
				The indices in the buffer vector may change when disusing any entity.
			**/
			final readWriteIndexMap: banker.vector.WritableVector<Int>;

			public function new(
				chunkCapacity: Int,
				defaultReadWriteIndexMap: banker.vector.Vector<Int>
			) {
				$b{prepared.constructorExpressions};
				this.readWriteIndexMap = defaultReadWriteIndexMap.ref.copyWritable();
			}

			/**
				Synchronizes all vectors and their corresponding buffer vectors.
			**/
			public function synchronize(
				chunkCapacity: Int,
				defaultReadWriteIndexMap: banker.vector.Vector<Int>
			): Int {
				$b{prepared.onSynchronizeExpressions};

				final nextWriteIndex = this.nextWriteIndex;
				$b{prepared.synchronizeExpressions};
				banker.vector.VectorTools.blitZero(
					defaultReadWriteIndexMap,
					this.readWriteIndexMap,
					chunkCapacity
				);

				this.endReadIndex = nextWriteIndex;
				return nextWriteIndex;
			}
		};

		chunkClass.doc = 'Chunk (or SoA: Structure of Arrays) class generated from the original Structure class `$structureName`.';
		chunkClass.pos = position;

		final fields = chunkClass.fields;
		fields.pushFromArray(prepared.chunkFields);

		return {
			typeDefinition: chunkClass,
			variables: prepared.variables,
			iterators: prepared.iterators,
			useMethods: prepared.useMethods
		};
	}

	static function scanBuildFields(buildFields: Fields) {
		final variables: Array<ChunkVariable> = [];
		final iteratorFunctions: Array<ChunkFunction> = [];
		final useFunctions: Array<ChunkFunction> = [];
		final chunkFields: Array<Field> = [];
		final constructorExpressions: Array<Expr> = [];
		final disuseExpressions: Array<Expr> = [];
		final synchronizeExpressions: Array<Expr> = [];
		final onSynchronizeExpressions: Array<Expr> = [];
		final chunkLevelVariableFields: Array<VariableField> = [];

		for (buildField in buildFields) {
			final buildFieldName = buildField.name;
			if (notVerified) debug('Found field: ${buildFieldName}');

			final metaMap = buildField.createMetadataMap();

			if (metaMap.hidden) {
				if (notVerified) debug('  Found metadata: ${MetadataNames.hidden} ... Skipping.');
				continue;
			}

			final access = buildField.access;
			final isStatic = access != null && access.has(AStatic);
			final hasChunkLevelMetadata = metaMap.chunkLevel;

			if (hasChunkLevelMetadata) {
				if (notVerified)
					debug('  Found metadata: @${MetadataNames.chunkLevel} ... Preserve as a chunk-level field.');
			}

			switch buildField.kind {
				case FFun(func):
					final onSynchronize = metaMap.onSynchronize || buildFieldName == "onSynchronize";
					if (onSynchronize) {
						if (notVerified) {
							if (metaMap.onSynchronize)
								debug('  Found metadata: ${MetadataNames.onSynchronize} ... Preserve as a chunk-level sync function.');
							else
								debug('  Found field onSynchronize ... Preserve as a chunk-level sync function.');
						}

						final expression = createOnSynchronizeExpression(buildField, func);
						if (expression.isFailedWarn()) continue;
						onSynchronizeExpressions.push(expression.unwrap());
					}

					if (hasChunkLevelMetadata || onSynchronize) {
						chunkFields.push(buildField);
						continue;
					}

					if (!isStatic) {
						// TODO: Check if non-static functions can be accepted as well
						if (notVerified) debug('  Function that is not static. Skipping.');
						continue;
					}

					if (!func.ret.isNullOrVoid()) {
						if (notVerified) debug('  Function with return value. Skipping.');
						continue;
					}

					final chunkMethodKind = getChunkMethodKind(metaMap);
					final chunkFunction = createChunkFunction(
						buildField,
						func,
						chunkMethodKind
					);

					switch chunkMethodKind {
						case UseEntity:
							useFunctions.push(chunkFunction);
							if (notVerified) {
								debug('  Found metadata: @${MetadataNames.useEntity}');
								debug('  Registered as a function for using new entity.');
							}
						case Iterate:
							iteratorFunctions.push(chunkFunction);
							if (notVerified) debug('  Registered as a Chunk iterator.');
					}

				case FVar(variableType, initialValue):
					if (variableType == null) {
						warn(
							'Type must be explicitly declared: $buildFieldName',
							buildField.pos
						);
						continue;
					}

					var isChunkLevel = hasChunkLevelMetadata;
					if (!isChunkLevel && isStatic) {
						debug('  Found a static variable. Preserve as a chunk-level field.');
						isChunkLevel = true;
					} else {
						switch (createChunkLevelConstructorExpression(
							buildFieldName,
							metaMap
						)) {
							case None:
							case Some(expression):
								debug('  Found metadata: @${MetadataNames.chunkLevelFactory}');
								constructorExpressions.push(expression);
						}
					}
					if (isChunkLevel) {
						if (metaMap.chunkLevelFinal) buildField.access.push(AFinal);
						chunkFields.push(buildField);
						chunkLevelVariableFields.push({
							field: buildField,
							type: variableType,
							expression: initialValue
						});
						continue;
					}

					final processed = processBuildFieldVariable(
						buildField,
						variableType,
						initialValue,
						metaMap
					);

					variables.push(processed.variable);
					chunkFields.pushFromArray(processed.chunkFields);

					final expressions = processed.expressions;
					constructorExpressions.push(expressions.constructor);
					synchronizeExpressions.push(expressions.synchronize);
					disuseExpressions.push(expressions.disuse);

					if (notVerified) debug('  Converted to vector.');

				default:
					warn(
						'Found field that is not a variable: ${buildFieldName}',
						buildField.pos
					);
			}
		}

		return {
			variables: variables,
			iteratorFunctions: iteratorFunctions,
			useFunctions: useFunctions,
			chunkFields: chunkFields,
			constructorExpressions: constructorExpressions,
			disuseExpressions: disuseExpressions,
			synchronizeExpressions: synchronizeExpressions,
			onSynchronizeExpressions: onSynchronizeExpressions,
			chunkLevelVariableFields: chunkLevelVariableFields
		}
	}

	/**
		Prepares the chunk class to be created.

		@return
		`variables`: Variables of each entity in the chunk.
		`chunkFields`: Fields of the chunk.
		`constructorExpressions`: Expression list to be reified in the chunk constructor.
	**/
	static function prepare(chunkClassName: String, buildFields: Array<Field>) {
		final scanned = scanBuildFields(buildFields);

		final variables = scanned.variables;
		final chunkFields = scanned.chunkFields;
		final disuseExpressions = scanned.disuseExpressions;
		final chunkLevelVariableFields = scanned.chunkLevelVariableFields;

		final iterators: Array<ChunkMethod> = [];
		for (func in scanned.iteratorFunctions) {
			if (notVerified) debug('Create iterator: ${func.name}');

			final iterator = createIterator(
				chunkClassName,
				func,
				variables,
				chunkLevelVariableFields,
				disuseExpressions
			);
			iterators.push(iterator);
			chunkFields.push(iterator.field);
		}

		final useMethods: Array<ChunkMethod> = [];
		for (func in scanned.useFunctions) {
			if (notVerified) debug('Create use method: ${func.name}');

			final useMethod = createUse(
				chunkClassName,
				func,
				variables,
				chunkLevelVariableFields
			);
			useMethods.push(useMethod);
			chunkFields.push(useMethod.field);
		}

		return {
			variables: variables,
			chunkFields: chunkFields,
			constructorExpressions: scanned.constructorExpressions,
			disuseExpressions: disuseExpressions,
			synchronizeExpressions: scanned.synchronizeExpressions,
			onSynchronizeExpressions: scanned.onSynchronizeExpressions,
			iterators: iterators,
			useMethods: useMethods
		};
	}
}
#end
