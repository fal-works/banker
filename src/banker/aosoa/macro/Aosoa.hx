package banker.aosoa.macro;

#if macro
class Aosoa {
	/**
		Creates an Aosoa (Array of Structure of Arrays) class,
		which consists of multiple chunk instances.
	**/
	public static function create(
		aosoaClassName: String,
		chunkClassPathString: String,
		chunk: ChunkDefinition,
		chunkType: ClassType
	): TypeDefinition {
		final chunkTypePath = chunkType.toTypePath();
		final chunkComplexType = Context.getType(chunkClassPathString).toComplexType();

		final aosoaClass = macro class $aosoaClassName {
			/**
				The chunks of which the Aosoa consists.
			**/
			public final chunks: banker.vector.Vector<$chunkComplexType>;

			/**
				The capacity of each chunk i.e. the length of each vector that a chunk contains.
			**/
			public final chunkCapacity: sinker.UInt;

			/**
				The total number of entities in `this` AoSoA, i.e. (chunk capacity) * (chunk count).
			**/
			public final capacity: sinker.UInt;

			/**
				Default values for `readWriteIndexMap` of the chunk class.
			**/
			final defaultReadWriteIndexMap: banker.vector.Vector<sinker.UInt>;

			/**
				The largest index of chunks that have any entity currently in use.
				The Aosoa iterates chunks until (but not including) this index.
			**/
			var endReadChunkIndex = sinker.UInt.zero;

			/**
				The smallest index of chunks that have any entity currently not in use.
				The Aosoa starts at this index when searching an available chunk to use a new entity.
			**/
			var nextWriteChunkIndex = sinker.UInt.zero;

			/**
				Synchronizes all chunks that have any entity in use.
			**/
			public function synchronize() {
				final chunks = this.chunks;
				final chunkCount = chunks.length;
				final chunkCapacity = this.chunkCapacity;
				final defaultReadWriteIndexMap = this.defaultReadWriteIndexMap;
				var usedChunkMaxIndex = sinker.UInt.zero;
				var endReadEntityIndex: sinker.UInt;

				var chunkIndex = sinker.UInt.zero;
				while (chunkIndex < chunkCount) {
					endReadEntityIndex = chunks[chunkIndex].synchronize(
						chunkCapacity,
						defaultReadWriteIndexMap
					);

					if (!endReadEntityIndex.isZero()) usedChunkMaxIndex = chunkIndex;

					++chunkIndex;
				}

				this.endReadChunkIndex = usedChunkMaxIndex + 1;
			}

			/**
				@return The chunk specified by `chunkEntityId`.
			**/
			public inline function getChunk(
				chunkEntityId: banker.aosoa.ChunkEntityId
			): $chunkComplexType {
				return this.chunks[chunkEntityId.chunk];
			}
		}

		final constructor = createConstructor(
			chunkTypePath,
			chunk.constructorExternalArguments
		);

		final fields = aosoaClass.fields;
		fields.insert(5, constructor);

		if (notVerified) debug('  Add iterator methods:');
		final iterators = chunk.iterators;
		for (i in 0...iterators.length) {
			final iterator = createIterater(iterators[i]);
			fields.push(iterator);
			if (notVerified) debug('  - ${iterator.name}');
		}

		if (notVerified) debug('  Add use methods:');
		final useMethods = chunk.useMethods;
		for (i in 0...useMethods.length) {
			final useMethod = createUseMethod(useMethods[i]);
			fields.push(useMethod);
			if (notVerified) debug('  - ${useMethod.name}');
		}

		aosoaClass.doc = 'AoSoA class generated from the original Structure/Chunk classes.';

		return aosoaClass;
	}

	/**
		@return `new()` field for AoSoA class.
	**/
	static function createConstructor(
		chunkTypePath: TypePath,
		externalArguments: Array<FunctionArg>
	): Field {
		final constructorArguments: Array<FunctionArg> = [
			{ name: "chunkCapacity", type: (macro:sinker.UInt) },
			{ name: "chunkCount", type: (macro:sinker.UInt) }
		];
		constructorArguments.pushFromArray(externalArguments);

		final chunkConstructorArguments: Array<Expr> = [
			macro chunkId++,
			macro chunkCapacity,
			macro defaultReadWriteIndexMap
		];
		chunkConstructorArguments.pushFromArray(externalArguments.map(arg ->
			macro $i{arg.name}));

		final constructor: Field = {
			name: "new",
			kind: FFun({
				args: constructorArguments,
				ret: null,
				expr: macro {
					final defaultReadWriteIndexMap = banker.vector.Vector.fromArrayCopy([for (i in 0...chunkCapacity) (i : sinker.UInt)]);

					var chunkId = sinker.UInt.zero;
					this.chunks = banker.vector.Vector.createPopulated(
						chunkCount,
						() -> new $chunkTypePath($a{chunkConstructorArguments})
					);
					this.chunkCapacity = chunkCapacity;
					this.capacity = chunkCount * chunkCapacity;
					this.defaultReadWriteIndexMap = defaultReadWriteIndexMap;
				}
			}),
			access: [APublic],
			pos: Context.currentPos()
		};
		return constructor;
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
			access: if (chunkField.access.existsAndHas(APublic)) [APublic] else []
		};

		return field;
	}

	/**
		Creates method for iterating over the entire Aosoa.
	**/
	static function createIterater(chunkIterator: ChunkMethod): Field {
		final chunkField = chunkIterator.field;
		final methodName = chunkField.name;

		final externalArguments = chunkIterator.externalArguments;
		final argumentExpressions = externalArguments.map(argument ->
			macro $i{argument.name});

		final functionBody = macro {
			final chunks = this.chunks;
			final chunkCapacity = this.chunkCapacity;
			final endReadChunkIndex = this.endReadChunkIndex;
			var i = sinker.UInt.zero;

			while (i < endReadChunkIndex) {
				final chunk = chunks[i];
				final nextWriteIndex = @:privateAccess chunk.$methodName($a{argumentExpressions});

				if (nextWriteIndex < chunkCapacity && i < this.nextWriteChunkIndex)
					this.nextWriteChunkIndex = i;

				++i;
			}
		};

		return createMethodField(chunkField, functionBody, externalArguments);
	}

	/**
		Creates method for using new entity in the Aosoa.
	**/
	static function createUseMethod(chunkUseMethod: ChunkMethod): Field {
		final chunkField = chunkUseMethod.field;
		final methodName = chunkField.name;

		final externalArguments = chunkUseMethod.externalArguments;
		final argumentExpressions = externalArguments.map(argument ->
			macro $i{argument.name});

		final functionBody = macro {
			final chunks = this.chunks;
			final chunkCapacity = this.chunkCapacity;

			var nextWriteChunkIndex = this.nextWriteChunkIndex;
			var chunk = chunks[nextWriteChunkIndex];
			while (chunk.nextWriteIndex == chunkCapacity) {
				++nextWriteChunkIndex;
				chunk = chunks[nextWriteChunkIndex];
			}

			chunk.$methodName($a{argumentExpressions});

			this.nextWriteChunkIndex = nextWriteChunkIndex;
		};

		return createMethodField(chunkField, functionBody, externalArguments);
	}
}
#end
