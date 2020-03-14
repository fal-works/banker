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

			public function new(chunkSize: Int, chunkCount: Int) {
				this.chunks = banker.vector.Vector.createPopulated(
					chunkCount,
					() -> new $chunkTypePath(chunkSize)
				);
				this.chunkSize = chunkSize;
			}
		}

		aosoaClass.pos = classPosition;

		final aosoaConstructor = aosoaClass.fields[2];
		aosoaConstructor.doc = "Aosoa class.";
		if (constructorPosition != null) aosoaConstructor.pos = constructorPosition;

		addIterators(aosoaClass.fields, chunk);

		return aosoaClass.fields;
	}

	static function addIterators(fields: Fields, chunk: Chunk.ChunkDefinition) {
		final iterators = chunk.iterators;

		for (i in 0...iterators.length) {
			fields.push(createCustomIterateMethod(iterators[i]));
		}

		return fields;
	}

	/**
		Creates method for adding to the Aosoa class.
	**/
	static function createCustomIterateMethod(iterator: Chunk.ChunkIterator) {
		final field = iterator.field;
		final name = field.name;
		final argumentExpressions = iterator.externalArguments.map(argument -> macro $i{argument.name});
		argumentExpressions.pop();
		argumentExpressions.push(macro endIndex);

		final functionBody = macro {
			final chunks = this.chunks;
			final chunkCount = chunks.length;
			final endIndex = this.chunkSize; // TODO: process only alive entities
			var i = 0;

			while (i < chunkCount) {
				final chunk = chunks[i];
				chunk.$name($a{argumentExpressions});
				++i;
			}
		};

		final iteratorFunction: Function = {
			args: iterator.externalArguments,
			ret: null,
			expr: functionBody
		};

		final field: Field = {
			name: name,
			kind: FFun(iteratorFunction),
			pos: field.pos,
			doc: field.doc,
			access: [APublic]
		};

		return field;
	}
}
#end
