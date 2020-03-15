package banker.aosoa.macro;

#if macro
class Aosoa {
	/**
		Creates an Aosoa (Array of Structure of Arrays) class,
		which consists of multiple chunk instances.
	**/
	public static function create(
		chunk: Chunk.ChunkDefinition,
		chunkTypePath: TypePath,
		classPosition: Position,
		?constructorPosition: Position
	): Fields {
		debug("Start rebuilding fields.");

		final chunkComplexType: ComplexType = TPath(chunkTypePath);

		final aosoaClass = macro class {
			public final chunks: banker.vector.Vector<$chunkComplexType>;
			public final chunkSize: Int;
			final defaultReadWriteIndexMap: banker.vector.Vector<Int>;
			var endReadChunkIndex = 0;
			var nextWriteChunkIndex = 0;

			public function new(chunkSize: Int, chunkCount: Int) {
				final defaultReadWriteIndexMap = banker.vector.Vector.fromArrayCopy([for (i in 0...chunkSize) i]);

				this.chunks = banker.vector.Vector.createPopulated(
					chunkCount,
					() -> new $chunkTypePath(chunkSize, defaultReadWriteIndexMap)
				);
				this.chunkSize = chunkSize;
				this.defaultReadWriteIndexMap = defaultReadWriteIndexMap;
			}

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
					else break;
				}

				this.endReadChunkIndex = usedChunkMaxIndex + 1;
			}
		}

		aosoaClass.pos = classPosition;

		final aosoaConstructor = aosoaClass.fields[5];
		aosoaConstructor.doc = "Aosoa class.";
		if (constructorPosition != null) aosoaConstructor.pos = constructorPosition;

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

		debug("  Rebuilt fields.");

		return fields;
	}

	static function createMethod(chunkField: Field, functionBody: Expr, externalArguments: Array<FunctionArg>) {
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
		Creates method for adding to the Aosoa class.
	**/
	static function createIterater(iterator: Chunk.ChunkMethod) {
		final field = iterator.field;
		final iteratorName = field.name;

		final externalArguments = iterator.externalArguments;
		final argumentExpressions = externalArguments.map(argument -> macro $i{argument.name});
		argumentExpressions.pop();

		final functionBody = macro {
			final chunks = this.chunks;
			final chunkSize = this.chunkSize;
			final endReadChunkIndex = this.endReadChunkIndex;
			var i = 0;

			while (i < endReadChunkIndex) {
				final chunk = chunks[i];
				final nextWriteIndex = chunk.$iteratorName($a{argumentExpressions});

				if (nextWriteIndex < chunkSize && i < this.nextWriteChunkIndex)
					this.nextWriteChunkIndex = i;

				++i;
			}
		};

		return createMethod(field, functionBody, externalArguments);
	}

	/**
		Creates method for using new entity to the Aosoa class.
	**/
	static function createUseMethod(iterator: Chunk.ChunkMethod) {
		final field = iterator.field;
		final useMethodName = field.name;

		final externalArguments = iterator.externalArguments;
		final argumentExpressions = externalArguments.map(argument -> macro $i{argument.name});

		final functionBody = macro {
			final chunks = this.chunks;
			final chunkSize = this.chunkSize;

			var nextWriteChunkIndex = this.nextWriteChunkIndex;
			var chunk = chunks[nextWriteChunkIndex];
			while(chunk.nextWriteIndex == chunkSize) {
				++nextWriteChunkIndex;
				chunk = chunks[nextWriteChunkIndex];
			}

			chunk.$useMethodName($a{argumentExpressions});

			this.nextWriteChunkIndex = nextWriteChunkIndex;
		};

		return createMethod(field, functionBody, externalArguments);
	}
}
#end
