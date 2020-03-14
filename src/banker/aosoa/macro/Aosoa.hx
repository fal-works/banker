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
			public final chunkCount: Int;

			public function new(chunkSize: Int, chunkCount: Int) {
				this.chunks = banker.vector.Vector.createPopulated(
					chunkCount,
					() -> new $chunkTypePath(chunkSize)
				);
				this.chunkSize = chunkSize;
				this.chunkCount = chunkCount;
			}
		}

		aosoaClass.pos = classPosition;

		final aosoaConstructor = aosoaClass.fields[3];
		aosoaConstructor.doc = "Aosoa class.";
		if (constructorPosition != null) aosoaConstructor.pos = constructorPosition;

		final iterate = createIterateMethod(chunk, classPosition);
		aosoaClass.fields.push(iterate);

		return aosoaClass.fields;
	}

	/**
		Creates `iterate()` method for adding to the Aosoa class.
	**/
	static function createIterateMethod(chunk: Chunk.ChunkDefinition, position: Position) {
		final functionBody = macro {
			final len = this.chunkCount;
			final chunkSize = this.chunkSize;
			var i = 0;

			while (i < len) {
				chunks[i].iterate(
					callback,
					chunkSize
				); // TODO: process only alive entities
				++i;
			}
		};

		final iterateFunction: Function = {
			args: [{
				name: "callback",
				type: chunk.iterateCallbackType
			}],
			ret: null,
			expr: functionBody
		};

		final field: Field = {
			name: "iterate",
			kind: FFun(iterateFunction),
			pos: position,
			doc: "Runs `callback` for each entity.",
			access: [APublic, AInline]
		};

		return field;
	}
}
#end
