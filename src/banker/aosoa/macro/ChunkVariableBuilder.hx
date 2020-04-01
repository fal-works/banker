package banker.aosoa.macro;

#if macro
using sneaker.macro.extensions.FieldExtension;

import haxe.ds.Option;

class ChunkVariableBuilder {
	/**
		Generates fields and corresponding expressions from `buildField`.
	**/
	public static function processBuildFieldVariable(
		buildField: Field,
		variableType: ComplexType,
		initialValue: Null<Expr>,
		metaMap: MetadataMap
	) {
		final chunkVariable = createChunkVariable(buildField, variableType);
		final chunkField = chunkVariable.field;
		final chunkBufferField = createChunkBufferField(chunkField);

		final constructor = createConstructorExpression(
			buildField,
			initialValue,
			metaMap
		);

		final synchronize = createSynchronizeExpression(
			buildField.name,
			chunkBufferField.name
		);

		final swap = metaMap.swap;
		if (notVerified && swap)
			debug('  Found metadata @${MetadataNames.swap} ... Swap buffer elements when disusing.');

		final disuse = createDisuseExpression(chunkBufferField.name, swap);

		return {
			variable: chunkVariable.data,
			chunkFields: [chunkVariable.field, chunkBufferField],
			expressions: {
				constructor: constructor,
				synchronize: synchronize,
				disuse: disuse
			}
		}
	}

	/**
		Creates an initializing expression (and an argument, if needed)
		for including in `new()`.
		Should not be used for static variables.
	**/
	public static function createChunkLevelConstructorPiece(
		variableFieldName: String,
		variableType: ComplexType,
		metaMap: MetadataMap
	): ConstructorPiece {
		return switch (metaMap.chunkLevelFactory) {
			case None:
				final argumentName = variableFieldName + "Value";
				FromArgument(
					macro this.$variableFieldName = $i{argumentName},
					{ name: argumentName, type: variableType }
				);
			case Some(factory):
				FromFactory(macro this.$variableFieldName = $factory(chunkCapacity));
		}
	}

	static function createChunkVariable(
		buildField: Field,
		variableType: ComplexType
	): { field: Field, data: ChunkVariable } {
		final documentation = if (buildField.doc != null)
			buildField.doc;
		else
			'Vector generated from variable `${buildField.name}` in the original Structure class.';

		final vectorType = macro:banker.vector.WritableVector<$variableType>;

		final field = buildField.clone()
			.setDoc(documentation).setVariableType(vectorType).setAccess([AFinal]);

		return {
			field: field,
			data: {
				name: buildField.name,
				type: variableType,
				vectorType: vectorType
			}
		}
	}

	static function createChunkBufferField(chunkField: Field): Field {
		final originalName = chunkField.name;
		final bufferName = originalName + "ChunkBuffer";
		final chunkBufferDocumentation = 'Vector for providing buffered WRITE access to `$originalName`.';

		return chunkField.clone().setName(bufferName).setDoc(chunkBufferDocumentation);
	}

	static function createDisuseExpression(
		chunkBufferFieldName: String,
		swap: Bool
	): Expr {
		return if (swap)
			macro $i{chunkBufferFieldName}.swap(i, nextWriteIndex);
		else
			macro $i{chunkBufferFieldName}[i] = $i{chunkBufferFieldName}[nextWriteIndex];
	}

	static function createSynchronizeExpression(fieldName: String, bufferName: String) {
		return macro banker.vector.VectorTools.blitZero(
			$i{bufferName},
			$i{fieldName},
			nextWriteIndex
		);
	}

	/**
		According to the definition and metadata of `buildField`,
		Creates an initializing expression for the corresponding vector field.

		Variable `chunkCapacity: Int` must be declared prior to this expression.

		@param initialValue Obtained from `buildField.kind`.
		@return Expression to be run in `new()`. `null` if the input is invalid.
	**/
	static function createConstructorExpression(
		buildField: Field,
		initialValue: Null<Expr>,
		metaMap: MetadataMap
	): Expr {
		final buildFieldName = buildField.name;

		final expressions: Array<Expr> = [];
		final thisField = macro $p{["this", buildFieldName]};

		expressions.push(macro $thisField = new banker.vector.WritableVector(chunkCapacity));

		if (initialValue != null) {
			expressions.push(macro $thisField.fill($initialValue));
		} else {
			switch (metaMap.factory) {
				case None:
					warn(
						'Field must be initialized or have @${MetadataNames.factory} metadata.',
						buildField.pos
					);
					return macro $a{expressions};
				case Some(factoryExpression):
					expressions.push(macro $thisField.populate($factoryExpression));
			}
		}

		final thisBuffer = macro $p{["this", buildFieldName + "ChunkBuffer"]};
		expressions.push(macro $thisBuffer = $thisField.ref.copyWritable());

		return macro $a{expressions};
	}
}
#end
