package banker.aosoa.macro;

#if macro
using banker.aosoa.macro.FieldExtension;

import banker.aosoa.macro.ChunkMethodBuilder.*;
import banker.aosoa.macro.ChunkVariableBuilder.*;

class Chunk {
	/**
		Creates a new Chunk class.
	**/
	public static function create(
		localClass: ClassType,
		chunkClassName: String,
		buildFields: Array<Field>,
		position: Position
	): ChunkDefinition {
		final prepared = prepare(localClass, chunkClassName, buildFields);
		final variables = prepared.variables;

		final chunkClass: TypeDefinition = macro class $chunkClassName {
			/**
				The id number of the chunk that is unique in an AoSoA.
			**/
			public final chunkId: sinker.UInt;

			/**
				The largest index of entities that are currently in use.
				The chunk iterates until (but not including) this index when iterating entities.
			**/
			public var endReadIndex(default, null) = sinker.UInt.zero;

			/**
				The first index of entities that are currently not in use.
				The chunk uses this index when using a new entity.
			**/
			public var nextWriteIndex(default, null) = sinker.UInt.zero;

			/**
				Table that maps entity IDs to physical indices in variable vectors.
			**/
			public final entityIdReadIndexMap: banker.vector.WritableVector<sinker.UInt>;

			/**
				Table that maps the indices between the main vector and the WRITE-buffer vector.
				The indices in the buffer vector may change when disusing any entity.
				This table is reset every time `synchronize()` is called.
			**/
			final readWriteIndexMap: banker.vector.WritableVector<sinker.UInt>;

			/**
				Synchronizes all vectors and their corresponding buffer vectors.
			**/
			public function synchronize(
				chunkCapacity: sinker.UInt,
				defaultReadWriteIndexMap: banker.vector.Vector<sinker.UInt>
			): sinker.UInt {
				$b{prepared.onSynchronizeExpressions};

				final nextWriteIndex = this.nextWriteIndex;

				$b{prepared.synchronizeExpressions};

				banker.vector.UIntVectorTools.blitInverse(
					this.entityId,
					this.entityIdReadIndexMap,
					nextWriteIndex
				);

				banker.vector.VectorTools.blitZero(
					defaultReadWriteIndexMap,
					this.readWriteIndexMap,
					chunkCapacity
				);

				this.endReadIndex = nextWriteIndex;

				$b{prepared.onCompleteSynchronizeExpressions};

				return nextWriteIndex;
			}

			/**
				@return The physical index in variable vectors at which the entity data is stored.
			**/
			public inline function getReadIndex(
				chunkEntityId: banker.aosoa.ChunkEntityId
			): sinker.UInt {
				return this.entityIdReadIndexMap[chunkEntityId.entity];
			}
		};

		chunkClass.doc = 'Chunk (or SoA: Structure of Arrays) class generated from the original Structure class.';
		chunkClass.pos = position;

		final constructor = createConstructor(
			prepared.constructorExternalArguments,
			prepared.constructorExpressions,
			position
		);

		final fields = chunkClass.fields;
		fields.insert(7, constructor);
		fields.pushFromArray(prepared.chunkFields);

		return {
			typeDefinition: chunkClass,
			constructorExternalArguments: prepared.constructorExternalArguments,
			variables: prepared.variables,
			iterators: prepared.iterators,
			useMethods: prepared.useMethods
		};
	}

	/**
		@return `new()` field for Chunk class.
	**/
	static function createConstructor(
		externalArguments: Array<FunctionArg>,
		expressions: Array<Expr>,
		position: Position
	): Field {
		final constructorArguments: Array<FunctionArg> = [
			{
				name: "chunkId",
				type: (macro:sinker.UInt)
			},
			{
				name: "chunkCapacity",
				type: (macro:sinker.UInt)
			},
			{
				name: "defaultReadWriteIndexMap",
				type: (macro:banker.vector.Vector<sinker.UInt>)
			}
		];
		constructorArguments.pushFromArray(externalArguments);

		final expression = macro {
			this.chunkId = chunkId;
			$b{expressions};

			this.entityIdReadIndexMap = banker.vector.UIntVectorTools.createSequenceNumbersWritable(
				sinker.UInt.zero,
				chunkCapacity
			);

			this.readWriteIndexMap = defaultReadWriteIndexMap.ref.copyWritable();

			final id = this.id;
			var i = sinker.UInt.zero;
			while (i < chunkCapacity) {
				id[i] = new banker.aosoa.ChunkEntityId(chunkId, i);
				++i;
			}
			banker.vector.VectorTools.blitZero(id, this.idChunkBuffer, chunkCapacity);

			banker.vector.UIntVectorTools.assignSequenceNumbers(
				this.entityId,
				sinker.UInt.zero
			);
			banker.vector.UIntVectorTools.assignSequenceNumbers(
				this.entityIdChunkBuffer,
				sinker.UInt.zero
			);
		};

		return {
			name: "new",
			kind: FFun({
				args: constructorArguments,
				ret: null,
				expr: expression
			}),
			access: [APublic],
			pos: position,
			doc: "Creates a Chunk instance. Called from `new()` of AoSoA class."
		};
	}

	static function scanBuildFields(localClass: ClassType, buildFields: Fields) {
		final variables: Array<ChunkVariable> = [];
		final iteratorFunctions: Array<ChunkFunction> = [];
		final useFunctions: Array<ChunkFunction> = [];
		final chunkFields: Array<Field> = [];
		final constructorExpressions: Array<Expr> = [];
		final disuseExpressions: Array<Expr> = [];
		final synchronizeExpressions: Array<Expr> = [];
		final onSynchronizeExpressions: Array<Expr> = [];
		final onCompleteSynchronizeExpressions: Array<Expr> = [];
		final chunkLevelVariableFields: Array<VariableField> = [];
		final constructorExternalArguments: Array<FunctionArg> = [];

		for (buildField in buildFields) {
			final buildFieldName = buildField.name;
			if (notVerified) debug('Found field: ${buildFieldName}');

			final metaMap = buildField.createMetadataMap();
			setLocalClass(localClass); // Set again as the verification state may be changed

			if (metaMap.hidden) {
				if (notVerified) debug('  Found metadata: ${MetadataNames.hidden} ... Skipping.');
				continue;
			}

			final access = buildField.access;
			final isStatic = access != null && access.has(AStatic);
			final hasChunkLevelMetadata = metaMap.chunkLevel;

			if (hasChunkLevelMetadata) {
				if (notVerified)
					debug('  Found metadata: @${MetadataNames.chunkLevel}');
			}

			switch buildField.kind {
				case FFun(func):
					if (hasChunkLevelMetadata) {
						chunkFields.push(buildField);

						if (metaMap.onSynchronize || metaMap.onCompleteSynchronize) {
							if (notVerified)
								debug('  Found metadata: @${metaMap.onSynchronize ? MetadataNames.onSynchronize : MetadataNames.onCompleteSynchronize}');

							final expression = createOnSynchronizeExpression(
								buildField,
								func,
								true
							);
							if (expression.isFailedWarn()) continue;

							if (metaMap.onSynchronize)
								onSynchronizeExpressions.push(expression.unwrap());
							else
								onCompleteSynchronizeExpressions.push(expression.unwrap());
						}

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
						case OnSynchronizeEntity(onComplete):
							final expression = createOnSynchronizeExpression(
								buildField,
								func,
								false
							);
							if (expression.isFailedWarn()) continue;
							iteratorFunctions.push(chunkFunction); // It's also a kind of iterator
							final array = onComplete ? onCompleteSynchronizeExpressions : onSynchronizeExpressions;
							array.push(expression.unwrap());
						case Iterate:
							iteratorFunctions.push(chunkFunction);
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
					if (!isChunkLevel) {
						if (isStatic) {
							if (notVerified)
								debug('  Found a static variable. Preserve as a chunk-level field.');
							isChunkLevel = true;
						}
					} else if (!isStatic) {
						// If chunk-level and not static,
						// initialize either by a factory or by an external argument of new().
						final constructorPiece = createChunkLevelConstructorPiece(
							buildFieldName,
							variableType,
							metaMap
						);
						if (initialValue == null) {
							switch (constructorPiece) {
								case FromFactory(expression):
									constructorExpressions.push(expression);
								case FromArgument(expression, argument):
									constructorExternalArguments.push(argument);
									constructorExpressions.push(expression);
							}
						}
					}
					if (isChunkLevel) {
						if (metaMap.chunkLevelFinal) buildField.access.pushIfAbsent(AFinal);
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

					switch (processed.constructorPiece) {
						case FromFactory(expression):
							constructorExpressions.push(expression);
						case FromArgument(expression, argument):
							constructorExpressions.push(expression);
							constructorExternalArguments.push(argument);
					}

					final expressions = processed.expressions;
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
			constructorExternalArguments: constructorExternalArguments,
			constructorExpressions: constructorExpressions,
			disuseExpressions: disuseExpressions,
			synchronizeExpressions: synchronizeExpressions,
			onSynchronizeExpressions: onSynchronizeExpressions,
			onCompleteSynchronizeExpressions: onCompleteSynchronizeExpressions,
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
	static function prepare(
		localClass: ClassType,
		chunkClassName: String,
		buildFields: Array<Field>
	) {
		final buildFieldsCopy = buildFields.copy();
		buildFieldsCopy.push(createIdField());
		buildFieldsCopy.push(createEntityIdField());

		final scanned = scanBuildFields(localClass, buildFieldsCopy);

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
			constructorExternalArguments: scanned.constructorExternalArguments,
			constructorExpressions: scanned.constructorExpressions,
			disuseExpressions: disuseExpressions,
			synchronizeExpressions: scanned.synchronizeExpressions,
			onSynchronizeExpressions: scanned.onSynchronizeExpressions,
			onCompleteSynchronizeExpressions: scanned.onCompleteSynchronizeExpressions,
			iterators: iterators,
			useMethods: useMethods
		};
	}

	static function createIdField(): Field {
		return {
			name: "id",
			kind: FVar(
				macro:banker.aosoa.ChunkEntityId,
				macro banker.aosoa.ChunkEntityId.dummy
			),
			pos: localPosition,
			doc: "The identifier of the entity that is unique in an AoSoA.",
			meta: [{
				name: MetadataNames.readOnly_,
				pos: localPosition
			}, {
				name: MetadataNames.swap_,
				pos: localPosition
			}]
		}
	}

	static function createEntityIdField(): Field {
		return {
			name: "entityId",
			kind: FVar((macro:sinker.UInt), macro sinker.UInt.zero),
			pos: localPosition,
			doc: "The identifier number of the entity that is unique in a Chunk.",
			meta: [{
				name: MetadataNames.readOnly_,
				pos: localPosition
			}, {
				name: MetadataNames.swap_,
				pos: localPosition
			}]
		}
	}
}
#end
