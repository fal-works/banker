package banker.aosoa.macro;

#if macro
using banker.array.ArrayExtension;
using banker.aosoa.macro.FieldExtension;
using banker.aosoa.macro.MacroExtension;

import sneaker.macro.MacroComparator.unifyComplex;

class ChunkMethodBuilder {
	/**
		According to the definition and metadata of `buildField`,
		Creates an initializing expression for the corresponding vector field.

		Variable `chunkCapacity: Int` must be declared prior to this expression.

		@param initialValue Obtained from `buildField.kind`.
		@return Expression to be run in `new()`. `null` if the input is invalid.
	**/
	public static function createConstructorExpression(
		buildField: Field,
		buildFieldName: String,
		initialValue: Null<Expr>
	): MacroResult<Expr> {
		final expressions: Array<Expr> = [];
		final thisField = macro $p{["this", buildFieldName]};

		expressions.push(macro $thisField = new banker.vector.WritableVector(chunkCapacity));

		if (initialValue != null) {
			expressions.push(macro $thisField.fill($initialValue));
		} else {
			final factory = buildField.getFactory();
			if (factory == null) {
				return Failed(
					'Field must be initialized or have @${MetadataNames.factory} metadata.',
					buildField.pos
				);
			}

			expressions.push(macro $thisField.populate($factory));
		}

		final thisBuffer = macro $p{["this", buildFieldName + "ChunkBuffer"]};
		expressions.push(macro $thisBuffer = $thisField.ref.copyWritable());

		return Ok(macro $b{expressions});
	}

	/**
		Tells what kind `argument` is. Used in `generateMethodPieces()`.
	**/
	public static function getArgumentKind(
		argument: FunctionArg,
		variables: Array<ChunkVariable>,
		chunkLevelVariableFields: Array<VariableField>
	): ArgumentKind {

		if (argument.argumentIsWriteIndex())
			return WriteIndex;

		if (argument.argumentIsDisuse())
			return Disuse;

		final argumentName = argument.name;
		final argumentType = argument.type;

		for (m in 0...variables.length) {
			final variable = variables[m];
			if (variable.name != argumentName) continue;

			if (unifyComplex(variable.type, argumentType))
				return Read;

			if (unifyComplex(variable.vectorType, argumentType))
				return Write;
		}

		for (m in 0...chunkLevelVariableFields.length) {
			final variable = chunkLevelVariableFields[m];
			final field = variable.field;
			if (field.name != argumentName) continue;
			if (!unifyComplex(variable.type, argumentType)) continue;
			final access = field.access;
			final isStatic = access != null && access.has(AStatic);
			final isFinal = access != null && access.has(AFinal);
			return ChunkLevel(isStatic, isFinal);
		}

		return External;
	}

	static function getArgumentKindDebugMessage(argumentKind: ArgumentKind): String {
		return switch argumentKind {
			case WriteIndex: "Found index for write access.";
			case Disuse: "Found special variable for disusing entity.";
			case Read: "Found corresponding variable.";
			case Write: "Found corresponding vector.";
			case ChunkLevel(isStatic, isFinal):
				'Found corresponding chunk-level ${isStatic ? "static " : ""}${isFinal ? "final " : ""}variable.';
			case External: "No corresponding variable. Add to external arguments.";
		}
	}

	/**
		Generates expression pieces for creating iterate/use method from an user-defined function.
	**/
	static function generateMethodPieces(
		chunkClassName: String,
		methodName: String,
		arguments: Array<FunctionArg>,
		variables: Array<ChunkVariable>,
		chunkLevelVariableFields: Array<VariableField>,
		position: Position
	) {
		final declareLocalBeforeLoop: Array<Expr> = [];
		final declareLocalInsideLoop: Array<Expr> = [];
		final saveLocalAfterLoop: Array<Expr> = [];
		final externalArguments: Array<FunctionArg> = [];
		var needsWriteAccess = false;
		var hasWriteIndex = false;

		if (notVerified) debug('  Scanning arguments.');
		for (k in 0...arguments.length) {
			final argument = arguments[k];
			final argumentKind = getArgumentKind(argument, variables, chunkLevelVariableFields);

			final argumentName = argument.name;
			if (notVerified)
				debug('  - $argumentName ... ${getArgumentKindDebugMessage(argumentKind)}');

			switch argumentKind {
				case WriteIndex:
					hasWriteIndex = true;
					continue;

				case Disuse:
					continue;

				case Read:
					// provide READ access to the buffer via $argumentName
					final writeVectorName = argumentName + "ChunkBuffer";
					declareLocalBeforeLoop.push(macro final $writeVectorName = this.$writeVectorName);
					declareLocalInsideLoop.push(macro final $argumentName = $i{writeVectorName}[i]);

				case Write:
					// provide WRITE access to the buffer via $argumentName
					final writeVectorName = argumentName + "ChunkBuffer";
					declareLocalBeforeLoop.push(macro final $argumentName = this.$writeVectorName);
					needsWriteAccess = true;

				case ChunkLevel(isStatic, isFinal):
					if (isStatic) {
						if (isFinal) {
							declareLocalBeforeLoop.push(macro final $argumentName = $i{chunkClassName}.$argumentName);
						} else {
							declareLocalBeforeLoop.push(macro var $argumentName = $i{chunkClassName}.$argumentName);
							saveLocalAfterLoop.push(macro $i{chunkClassName}.$argumentName = $i{argumentName});
						}
					} else {
						if (isFinal) {
							declareLocalBeforeLoop.push(macro final $argumentName = this.$argumentName);
						} else {
							declareLocalBeforeLoop.push(macro var $argumentName = this.$argumentName);
							saveLocalAfterLoop.push(macro this.$argumentName = $i{argumentName});
						}
					}

				case External:
					externalArguments.push(argument);
			}
		}

		if (needsWriteAccess && !hasWriteIndex)
			warn(
				'Found vector argument but missing argument `i: Int` in function $methodName().',
				position
			);

		return {
			declareLocalInsideLoop: declareLocalInsideLoop,
			declareLocalBeforeLoop: declareLocalBeforeLoop,
			saveLocalAfterLoop: saveLocalAfterLoop,
			externalArguments: externalArguments
		};
	}

	/**
		Creates field from given information.
		Used in `createIterator()` and `createUseMethod()`.
	**/
	static function createMethodField(
		originalFunction: ChunkFunction,
		builtFunction: Function
	): Field {
		final field: Field = {
			name: originalFunction.name,
			kind: FFun(builtFunction),
			pos: originalFunction.position,
			doc: originalFunction.documentation,
			access: [APublic, AInline]
		};

		return field;
	}

	/**
		Creates method for iterating over the chunk.
	**/
	public static function createIterator(
		chunkClassName: String,
		originalFunction: ChunkFunction,
		variables: Array<ChunkVariable>,
		chunkLevelVariableFields: Array<VariableField>,
		disuseExpressions: Array<Expr>
	): ChunkMethod {
		final pieces = generateMethodPieces(
			chunkClassName,
			originalFunction.name,
			originalFunction.arguments,
			variables,
			chunkLevelVariableFields,
			originalFunction.position
		);
		final externalArguments = pieces.externalArguments;

		final initializeBeforeLoops: Array<Expr> = [];
		initializeBeforeLoops.pushFromArray(pieces.declareLocalBeforeLoop);
		initializeBeforeLoops.push(macro final readWriteIndexMap = this.readWriteIndexMap);
		initializeBeforeLoops.push(macro final endReadIndex = this.endReadIndex);
		initializeBeforeLoops.push(macro var readIndex = 0);
		initializeBeforeLoops.push(macro var nextWriteIndex = this.nextWriteIndex);
		initializeBeforeLoops.push(macro var disuse = false);
		initializeBeforeLoops.push(macro var i = 0);

		final initializeLoop: Array<Expr> = [];
		initializeLoop.push(macro i = readWriteIndexMap[readIndex]);
		initializeLoop.pushFromArray(pieces.declareLocalInsideLoop);

		final finalizeLoop: Array<Expr> = [];
		finalizeLoop.push(macro if (disuse) {
			--nextWriteIndex;
			$b{disuseExpressions};
			readWriteIndexMap.swap(i, nextWriteIndex);
			disuse = false;
		});
		finalizeLoop.push(macro ++readIndex);

		final finalizeAfterLoops: Array<Expr> = [];
		finalizeAfterLoops.push(macro this.nextWriteIndex = nextWriteIndex);
		finalizeAfterLoops.pushFromArray(pieces.saveLocalAfterLoop);

		final loopBodyExpressions: Array<Expr> = [];
		loopBodyExpressions.pushFromArray(initializeLoop);
		loopBodyExpressions.push(originalFunction.expression);
		loopBodyExpressions.pushFromArray(finalizeLoop);

		final loopStatement = macro while (readIndex < endReadIndex) $b{loopBodyExpressions};

		final wholeExpressions: Array<Expr> = [];
		wholeExpressions.pushFromArray(initializeBeforeLoops);
		wholeExpressions.push(loopStatement);
		wholeExpressions.pushFromArray(finalizeAfterLoops);
		wholeExpressions.push(macro return this.nextWriteIndex);

		final iteratorFunction: Function = {
			args: externalArguments,
			ret: (macro:Int),
			expr: macro $b{wholeExpressions}
		};

		// This will generate something like the below:
		/*
			function someIterator(externalArgs) {
				declareLocalBeforeLoop();

				final readWriteIndexMap = this.readWriteIndexMap;
				final endReadIndex = this.endReadIndex;
				var readIndex = 0;
				var nextWriteIndex = this.nextWriteIndex
				var disuse = false;
				var i: Int;

				while (readIndex < endReadIndex) {
					i = readWriteIndexMap[readIndex]; // write index
					declareLocalInsideLoop();

					originalFunction();

					if (disuse) {
						--nextWriteIndex;
						disuseExpr();
						readWriteIndexMap.swap(i, nextWriteIndex);
						disuse = false;
					}

					++readIndex;
				}

				this.nextWriteIndex = nextWriteIndex
				saveLocalAfterLoop();

				return nextWriteIndex;
			}
		**/

		return {
			field: createMethodField(originalFunction, iteratorFunction),
			externalArguments: externalArguments
		};
	}

	/**
		Creates method for using new entity in the chunk.
	**/
	public static function createUse(
		chunkClassName: String,
		originalFunction: ChunkFunction,
		variables: Array<ChunkVariable>,
		chunkLevelVariableFields: Array<VariableField>
	): ChunkMethod {
		final pieces = generateMethodPieces(
			chunkClassName,
			originalFunction.name,
			originalFunction.arguments,
			variables,
			chunkLevelVariableFields,
			originalFunction.position
		);
		final externalArguments = pieces.externalArguments;

		final expressions: Array<Expr> = [];
		expressions.push(macro final i = this.nextWriteIndex);
		expressions.pushFromArray(pieces.declareLocalBeforeLoop);
		expressions.pushFromArray(pieces.declareLocalInsideLoop); // Not sure if it is necessary

		expressions.push(originalFunction.expression);

		expressions.push(macro final nextIndex = i + 1);
		expressions.push(macro this.nextWriteIndex = nextIndex);
		expressions.pushFromArray(pieces.saveLocalAfterLoop);

		expressions.push(macro return nextIndex);

		final useFunction: Function = {
			args: externalArguments,
			ret: (macro:Int),
			expr: macro $b{expressions}
		};

		// This will generate something like the below:
		/*
			function use(externalArgs) {
				final i = this.nextWriteIndex;
				declareLocalBeforeLoop();
				declareLocalInsideLoop();

				originalFunction();

				final nextIndex = i + 1;
				this.nextWriteIndex = nextIndex;
				saveLocalAfterLoop();

				return nextIndex;
			}
		**/

		return {
			field: createMethodField(originalFunction, useFunction),
			externalArguments: externalArguments
		};
	}
}
#end
