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
		final chunkComplexType: ComplexType = TPath(chunkTypePath);

		final aosoaClass = macro class {
			public final chunks: banker.vector.Vector<$chunkComplexType>;
			public final chunkSize: Int;
			var chunkIndex = 0;
			var slotIndex = 0;

			public function new(chunkSize: Int, chunkCount: Int) {
				this.chunks = banker.vector.Vector.createPopulated(
					chunkCount,
					() -> new $chunkTypePath(chunkSize)
				);
				this.chunkSize = chunkSize;
			}

			public function synchronize() {
				final chunks = this.chunks;
				final chunkSize = this.chunkSize;
				for (i in 0...chunkIndex + 1) chunks[i].synchronize(chunkSize);
			}
		}

		aosoaClass.pos = classPosition;

		final aosoaConstructor = aosoaClass.fields[4];
		aosoaConstructor.doc = "Aosoa class.";
		if (constructorPosition != null) aosoaConstructor.pos = constructorPosition;

		final fields = aosoaClass.fields;

		final iterators = chunk.iterators;
		for (i in 0...iterators.length)
			fields.push(createIterater(iterators[i]));

		final useMethods = chunk.useMethods;
		for (i in 0...useMethods.length)
			fields.push(createUseMethod(useMethods[i]));

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
		final methodName = field.name;

		final externalArguments = iterator.externalArguments;
		final argumentExpressions = externalArguments.map(argument -> macro $i{argument.name});
		argumentExpressions.pop();
		argumentExpressions.push(macro endIndex);

		final functionBody = macro {
			final chunks = this.chunks;
			final chunkCount = chunks.length;
			final endIndex = this.chunkSize; // TODO: process only alive entities
			var i = 0;

			while (i < chunkCount) {
				final chunk = chunks[i];
				chunk.$methodName($a{argumentExpressions});
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
		final methodName = field.name;

		final externalArguments = iterator.externalArguments;
		final argumentExpressions = externalArguments.map(argument -> macro $i{argument.name});
		argumentExpressions.push(macro slotIndex);

		final functionBody = macro {
			final chunks = this.chunks;

			final chunkIndex = this.chunkIndex;
			var slotIndex = this.slotIndex;

			final chunk = chunks[chunkIndex];
			chunk.$methodName($a{argumentExpressions});

			++slotIndex;
			if (slotIndex < this.chunkSize) {
				this.slotIndex = slotIndex;
			} else {
				this.chunkIndex = chunkIndex + 1;
				this.slotIndex = 0;
			}
		};

		return createMethod(field, functionBody, externalArguments);
	}
}
#end
