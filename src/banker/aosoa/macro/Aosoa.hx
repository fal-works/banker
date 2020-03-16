package banker.aosoa.macro;

#if macro
import banker.aosoa.macro.MacroTypes.DefinedType;

class Aosoa {
	/**
		Creates an Aosoa (Array of Structure of Arrays) class,
		which consists of multiple chunk instances.
	**/
	public static function create(
		structureName: String,
		chunk: Chunk.ChunkDefinition,
		chunkType: DefinedType,
		classPosition: Position
	): TypeDefinition {
		debug("Start to create Aosoa class.");

		final aosoaClassName = structureName + "Aosoa";

		final chunkTypePath = chunkType.path;
		final chunkComplexType = chunkType.complex;

		final aosoaClass = macro class $aosoaClassName {
			/**
				The chunks of which the Aosoa consists.
			**/
			public final chunks: banker.vector.Vector<$chunkComplexType>;

			/**
				The size of each chunk i.e. the length of each vector that a chunk contains.
			**/
			public final chunkSize: Int;

			/**
				Default values for `readWriteIndexMap` of the chunk class.
			**/
			final defaultReadWriteIndexMap: banker.vector.Vector<Int>;

			/**
				The largest index of chunks that have any entity currently in use.
				The Aosoa iterates chunks until (but not including) this index.
			**/
			var endReadChunkIndex = 0;

			/**
				The smallest index of chunks that have any entity currently not in use.
				The Aosoa starts at this index when searching an available chunk to use a new entity.
			**/
			var nextWriteChunkIndex = 0;

			/**
				Called from `createAosoa()` that is added to the original Structure class by the build macro.
			**/
			public function new(chunkSize: Int, chunkCount: Int) {
				final defaultReadWriteIndexMap = banker.vector.Vector.fromArrayCopy([for (i in 0...chunkSize) i]);

				this.chunks = banker.vector.Vector.createPopulated(
					chunkCount,
					() -> new $chunkTypePath(chunkSize, defaultReadWriteIndexMap)
				);
				this.chunkSize = chunkSize;
				this.defaultReadWriteIndexMap = defaultReadWriteIndexMap;
			}

			/**
				Synchronizes all chunks that have any entity in use.
			**/
			public function synchronize() {
				final chunks = this.chunks;
				final chunkCount = chunks.length;
				final chunkSize = this.chunkSize;
				final defaultReadWriteIndexMap = this.defaultReadWriteIndexMap;
				var usedChunkMaxIndex = 0;
				var endReadEntityIndex = chunkSize;

				for (chunkIndex in 0...chunkCount) {
					endReadEntityIndex = chunks[chunkIndex].synchronize(
						chunkSize,
						defaultReadWriteIndexMap
					);

					if (endReadEntityIndex > 0) usedChunkMaxIndex = chunkIndex;
					else break; // TODO: do not break?
				}

				this.endReadChunkIndex = usedChunkMaxIndex + 1;
			}
		}

		aosoaClass.pos = classPosition;
		aosoaClass.doc = 'Aosoa class generated from the original structure class `$structureName`.';

		final fields = aosoaClass.fields;

		debug('  Add iterator methods:');
		final iterators = chunk.iterators;
		for (i in 0...iterators.length) {
			final iterator = createIterater(iterators[i]);
			fields.push(iterator);
			debug('  - ${iterator.name}');
		}

		debug('  Add use methods:');
		final useMethods = chunk.useMethods;
		for (i in 0...useMethods.length) {
			final useMethod = createUseMethod(useMethods[i]);
			fields.push(useMethod);
			debug('  - ${useMethod.name}');
		}

		debug("  Created Aosoa class.");

		return aosoaClass;
	}

	public static function createAosoaCreatorMethod(aosoaType: DefinedType, position: Position): Field {
		final aosoaTypePath = aosoaType.path;
		final functionBody = macro return new $aosoaTypePath(chunkSize, chunkCount);
		var documentation = 'Creates an AoSoA (Array of Structure of Arrays) instance.';
		documentation += '\n\nAn Aosoa consists of multiple Chunks (or SoA: Structure of Arrays),';
		documentation += '\nand each Chunk consists of vectors containing the data of entities.';
		documentation += '\nThe total capacity of entities will be `chunkSize * chunkCount`.';
		documentation += '\n@param chunkSize The capacity of each Chunk i.e. the length of each vector that a Chunk contains.';
		documentation += '\n@param chunkCount The number of Chunks that the AoSoA contains.';

		final createAosoaMethod: Field = {
			name: "createAosoa",
			kind: FFun({
				args: [
					{ name: "chunkSize", type: (macro:Int)},
					{ name: "chunkCount", type: (macro:Int)}
				],
				ret: aosoaType.complex,
				expr: functionBody
			}),
			access: [APublic, AStatic],
			doc: documentation,
			pos: position
		};
		return createAosoaMethod;
	}

	/**
		Creates field from given information.
		Used in `createIterator()` and `createUseMethod()`.
	**/
	static function createMethodField(
		chunkField: Field,
		functionBody: Expr,
		externalArguments: Array<FunctionArg>
	): Field {
		final builtFunction: Function = {
			args: externalArguments,
			ret: null,
			expr: functionBody
		};

		final field: Field = {
			name: chunkField.name,
			kind: FFun(builtFunction),
			pos: chunkField.pos,
			doc: chunkField.doc,
			access: [APublic]
		};

		return field;
	}

	/**
		Creates method for iterating over the entire Aosoa.
	**/
	static function createIterater(chunkIterator: Chunk.ChunkMethod): Field {
		final chunkField = chunkIterator.field;
		final methodName = chunkField.name;

		final externalArguments = chunkIterator.externalArguments;
		final argumentExpressions = externalArguments.map(argument -> macro $i{argument.name});

		final functionBody = macro {
			final chunks = this.chunks;
			final chunkSize = this.chunkSize;
			final endReadChunkIndex = this.endReadChunkIndex;
			var i = 0;

			while (i < endReadChunkIndex) {
				final chunk = chunks[i];
				final nextWriteIndex = chunk.$methodName($a{argumentExpressions});

				if (nextWriteIndex < chunkSize && i < this.nextWriteChunkIndex)
					this.nextWriteChunkIndex = i;

				++i;
			}
		};

		return createMethodField(
			chunkField,
			functionBody,
			externalArguments
		);
	}

	/**
		Creates method for using new entity in the Aosoa.
	**/
	static function createUseMethod(chunkUseMethod: Chunk.ChunkMethod): Field {
		final chunkField = chunkUseMethod.field;
		final methodName = chunkField.name;

		final externalArguments = chunkUseMethod.externalArguments;
		final argumentExpressions = externalArguments.map(argument -> macro $i{argument.name});

		final functionBody = macro {
			final chunks = this.chunks;
			final chunkSize = this.chunkSize;

			var nextWriteChunkIndex = this.nextWriteChunkIndex;
			var chunk = chunks[nextWriteChunkIndex];
			while (chunk.nextWriteIndex == chunkSize) {
				++nextWriteChunkIndex;
				chunk = chunks[nextWriteChunkIndex];
			}

			chunk.$methodName($a{argumentExpressions});

			this.nextWriteChunkIndex = nextWriteChunkIndex;
		};

		return createMethodField(
			chunkField,
			functionBody,
			externalArguments
		);
	}
}
#end
