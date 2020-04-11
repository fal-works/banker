package banker.aosoa.macro;

#if macro
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using sneaker.macro.extensions.FieldExtension;
using sneaker.macro.extensions.ExprExtension;

import haxe.macro.Context;
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
		final chunkVariable = createChunkVariable(buildField, variableType, metaMap);
		final chunkField = chunkVariable.field;
		final chunkBufferField = createChunkBufferField(chunkField);

		final constructorPiece = createConstructorPiece(
			buildField,
			variableType,
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
			constructorPiece: constructorPiece,
			expressions: {
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
				if (metaMap.externalFactory) {
					if (notVerified) {
						debug('  Found metadata: @${MetadataNames.externalFactory}');
						debug('  To be initialized with factory given by new() argument.');
					}
					final argumentName = variableFieldName + "Factory";
					FromArgument(
						macro this.$variableFieldName = $i{argumentName}(),
						{ name: argumentName, type: (macro:() -> $variableType) }
					);
				} else {
					if (notVerified) {
						debug('  Found neither initial value nor factory.');
						debug('  To be initialized by new() argument.');
					}
					final argumentName = variableFieldName + "Value";
					FromArgument(
						macro this.$variableFieldName = $i{argumentName},
						{ name: argumentName, type: variableType }
					);
				}
			case Some(factory):
				if (notVerified)
					debug('  Found metadata: @${MetadataNames.chunkLevelFactory}');
				FromFactory(macro this.$variableFieldName = $factory(chunkCapacity));
		}
	}

	static final factoryType = (macro:() -> Dynamic);
	static final factoryWithIdType = (macro:(id: banker.aosoa.ChunkEntityId) -> Dynamic);

	static function createChunkVariable(
		buildField: Field,
		variableType: ComplexType,
		metaMap: MetadataMap
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
				vectorType: vectorType,
				readOnly: metaMap.readOnly
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
	static function createConstructorPiece(
		buildField: Field,
		variableType: ComplexType,
		initialValue: Null<Expr>,
		metaMap: MetadataMap
	): ConstructorPiece {
		final buildFieldName = buildField.name;

		final expressions: Array<Expr> = [];
		final vector = macro this.$buildFieldName;

		expressions.push(macro $vector = new banker.vector.WritableVector(chunkCapacity));

		var argument: Null<FunctionArg> = null;

		if (initialValue != null) {
			expressions.push(macro $vector.fill($initialValue));
		} else switch (metaMap.factory) {
			case None:
				if (metaMap.externalFactory) {
					if (notVerified) {
						debug('  Found metadata: @${MetadataNames.externalFactory}');
						debug('  To be initialized with factory given by new() argument.');
					}
					final argumentName = buildFieldName + "Factory";
					expressions.push(macro $vector.populate($i{argumentName}));
					argument = {
						name: argumentName,
						type: (macro:() -> $variableType)
					};
				} else {
					if (notVerified)
						debug('  Found neither initial value nor factory. To be initialized by new() argument.');
					final argumentName = buildFieldName + "Value";
					expressions.push(macro $vector.fill($i{argumentName}));
					argument = {
						name: argumentName,
						type: variableType
					};
				}
			case Some(factoryExpression):
				if (notVerified) debug('  Found metadata: @${MetadataNames.factory}');
				final position = buildField.pos;
				final expr = if (factoryExpression.unify(factoryType))
					macro $vector.populate($factoryExpression);
				else if (factoryExpression.unify(factoryWithIdType))
					macro {
						var i = 0;
						$vector.populate(() -> {
							final value = $factoryExpression(new banker.aosoa.ChunkEntityId(chunkId, i));
							++i;
							return value;
						});
					};
				else
					throw new Error("Invalid factory function", position);
				expressions.push(expr);
		}

		final vectorBuffer = macro $p{["this", buildFieldName + "ChunkBuffer"]};
		expressions.push(macro $vectorBuffer = $vector.ref.copyWritable());

		final expression = macro $a{expressions};
		return switch argument {
			case null: FromFactory(expression);
			case argumentObject: FromArgument(expression, argumentObject);
		}
	}
}
#end
