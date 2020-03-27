package banker.aosoa.macro;

#if macro
using sneaker.macro.extensions.FieldExtension;
using banker.array.ArrayExtension;
using banker.aosoa.macro.FieldExtension;
using banker.aosoa.macro.MacroExtension;

import sneaker.macro.ComplexTypes;
import sneaker.macro.Types;
import sneaker.macro.MacroComparator.unifyComplex;
import banker.aosoa.macro.ChunkMethodBuilder.*;

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

	/**
		Prepares the chunk class to be created.

		@return
		`variables`: Variables of each entity in the chunk.
		`chunkFields`: Fields of the chunk.
		`constructorExpressions`: Expression list to be reified in the chunk constructor.
	**/
	static function prepare(chunkClassName: String, buildFields: Array<Field>) {
		final variables: Array<ChunkVariable> = [];
		final iteratorFunctions: Array<ChunkFunction> = [];
		final useFunctions: Array<ChunkFunction> = [];
		final chunkFields: Array<Field> = [];
		final constructorExpressions: Array<Expr> = [];
		final disuseExpressions: Array<Expr> = [];
		final synchronizeExpressions: Array<Expr> = [];
		final chunkLevelVariableFields: Array<VariableField> = [];

		for (i in 0...buildFields.length) {
			final buildField = buildFields[i];
			final buildFieldName = buildField.name;
			if (notVerified) debug('Found field: ${buildFieldName}');

			final access = buildField.access;

			if (buildField.hasMetadata(MetadataNames.hidden)) {
				if (notVerified) debug('  Found metadata: ${MetadataNames.hidden} ... Skipping.');
				continue;
			}

			final isStatic = access != null && access.has(AStatic);
			final hasChunkLevelMetadata = buildField.hasMetadata(MetadataNames.chunkLevel);

			if (hasChunkLevelMetadata) {
				if (notVerified)
					debug('  Found metadata: ${MetadataNames.chunkLevel} ... Preserve as a chunk-level field.');
			}

			switch buildField.kind {
				case FFun(func):
					if (hasChunkLevelMetadata) {
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

					final chunkMethodKind = getChunkMethodKind(buildField);
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
					var isChunkLevel = hasChunkLevelMetadata;
					if (!isChunkLevel && isStatic) {
						debug('  Found a static variable. Preserve as a chunk-level field.');
						isChunkLevel = true;
					}
					if (isChunkLevel) {
						chunkFields.push(buildField);
						chunkLevelVariableFields.push({
							field: buildField,
							type: variableType,
							expression: initialValue
						});
						continue;
					}

					if (variableType == null) {
						warn(
							'Type must be explicitly declared: $buildFieldName',
							buildField.pos
						);
						continue;
					}

					final constructorExpression = createConstructorExpression(
						buildField,
						buildFieldName,
						initialValue
					);
					if (constructorExpression.isFailedWarn()) break;
					constructorExpressions.push(constructorExpression.unwrap());

					final documentation = createChunkVectorDocumentation(buildField);

					final vectorType = macro:banker.vector.WritableVector<$variableType>;
					final chunkField = buildField.clone()
						.setDoc(documentation).setVariableType(vectorType).setAccess([AFinal]);

					chunkFields.push(chunkField);

					final chunkBufferFieldName = buildFieldName + "ChunkBuffer";
					final chunkBufferDocumentation = 'Vector for providing buffered WRITE access to `$buildFieldName`.';
					final chunkBufferField = chunkField.clone()
						.setName(chunkBufferFieldName).setDoc(chunkBufferDocumentation);
					chunkFields.push(chunkBufferField);

					synchronizeExpressions.push(macro banker.vector.VectorTools.blitZero(
						$i{chunkBufferFieldName},
						$i{buildFieldName},
						nextWriteIndex
					));

					final swap = buildField.hasMetadata(MetadataNames.swap);
					if (notVerified && swap)
						debug('  Found metadata @${MetadataNames.swap} ... Swap buffer elements when disusing.');

					final disuseExpression = if (swap)
						macro $i{chunkBufferFieldName}.swap(i, nextWriteIndex);
					else
						macro $i{chunkBufferFieldName}[i] = $i{chunkBufferFieldName}[nextWriteIndex];
					disuseExpressions.push(disuseExpression);

					variables.push({
						name: buildFieldName,
						type: variableType,
						vectorType: vectorType
					});

					if (notVerified) debug('  Converted to vector.');

				default:
					warn(
						'Found field that is not a variable: ${buildFieldName}',
						buildField.pos
					);
			}
		}

		final iterators: Array<ChunkMethod> = [];
		for (i in 0...iteratorFunctions.length) {
			final func = iteratorFunctions[i];
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
		for (i in 0...useFunctions.length) {
			final func = useFunctions[i];
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
			constructorExpressions: constructorExpressions,
			disuseExpressions: disuseExpressions,
			synchronizeExpressions: synchronizeExpressions,
			iterators: iterators,
			useMethods: useMethods
		};
	}

	static function createChunkVectorDocumentation(buildField: Field): String {
		return if (buildField.doc != null)
			buildField.doc;
		else
			'Vector generated from variable `${buildField.name}` in the original Structure class.';
	}
}
#end
