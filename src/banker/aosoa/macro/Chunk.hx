package banker.aosoa.macro;

#if macro
using sneaker.macro.FieldExtension;
using banker.array.ArrayExtension;
using banker.aosoa.macro.FieldExtension;
using banker.aosoa.macro.MacroExtension;

import sneaker.macro.ComplexTypes;
import sneaker.macro.Types;
import sneaker.macro.MacroComparator.unifyComplex;

/**
	Information about each variable of entity.
**/
typedef ChunkVariable = {
	name: String,
	type: ComplexType,
	vectorType: ComplexType
};

/**
	Information about each function of entity.
**/
typedef ChunkFunction = {
	name: String,
	arguments: Array<FunctionArg>,
	expression: Expr,
	documentation: String,
	position: Position
}

/**
	Method field for Chunk class.
	Generated from `ChunkFunction`.
**/
typedef ChunkMethod = {
	field: Field,
	externalArguments: Array<FunctionArg>
};

/**
	Information about a Chunk class to be defined in any module.
**/
typedef ChunkDefinition = {
	typeDefinition: TypeDefinition,
	variables: Array<ChunkVariable>,
	iterators: Array<ChunkMethod>,
	useMethods: Array<ChunkMethod>
};

class Chunk {
	/**
		Creates a new Chunk class.
	**/
	public static function create(
		buildFields: Array<Field>,
		structureName: String,
		position: Position
	): ChunkDefinition {
		final prepared = prepare(buildFields);
		final variables = prepared.variables;

		final chunkClassName = structureName + "Chunk";
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
				chunkSize: Int,
				defaultReadWriteIndexMap: banker.vector.Vector<Int>
			) {
				$b{prepared.constructorExpressions};
				this.readWriteIndexMap = defaultReadWriteIndexMap.ref.copyWritable();
			}

			/**
				Synchronizes all vectors and their corresponding buffer vectors.
			**/
			public function synchronize(
				chunkSize: Int,
				defaultReadWriteIndexMap: banker.vector.Vector<Int>
			): Int {
				final nextWriteIndex = this.nextWriteIndex;
				$b{prepared.synchronizeExpressions};
				banker.vector.VectorTools.blitZero(
					defaultReadWriteIndexMap,
					this.readWriteIndexMap,
					chunkSize
				);

				this.endReadIndex = nextWriteIndex;
				return nextWriteIndex;
			}
		};

		chunkClass.fields = chunkClass.fields.concat(prepared.chunkFields);
		chunkClass.doc = 'Chunk (or SoA: Structure of Arrays) class generated from the original Structure class `$structureName`.';
		chunkClass.pos = position;

		return {
			typeDefinition: chunkClass,
			variables: prepared.variables,
			iterators: prepared.iterators,
			useMethods: prepared.useMethods
		};
	}

	/**
		According to the definition and metadata of `buildField`,
		Creates an initializing expression for the corresponding vector field.

		Variable `chunkSize: Int` must be declared prior to this expression.

		@param initialValue Obtained from `buildField.kind`.
		@return Expression to be run in `new()`. `null` if the input is invalid.
	**/
	static function createConstructorExpression(
		buildField: Field,
		buildFieldName: String,
		initialValue: Null<Expr>
	): Null<Expr> {
		final expressions: Array<Expr> = [];
		final thisField = macro $p{["this", buildFieldName]};

		expressions.push(macro $thisField = new banker.vector.WritableVector(chunkSize));

		if (initialValue != null) {
			expressions.push(macro $thisField.fill($initialValue));
		} else {
			final factory = buildField.getFactory();
			if (factory == null) return null;

			expressions.push(macro $thisField.populate($factory));
		}

		final thisBuffer = macro $p{["this", buildFieldName + "ChunkBuffer"]};
		expressions.push(macro $thisBuffer = $thisField.ref.copyWritable());

		return macro $b{expressions};
	}

	/**
		Prepares the chunk class to be created.

		@return
		`variables`: Variables of each entity in the chunk.
		`chunkFields`: Fields of the chunk, each of which is a vector type variable.
		`constructorExpressions`: Expression list to be reified in the chunk constructor.
	**/
	static function prepare(buildFields: Array<Field>) {
		final variables: Array<ChunkVariable> = [];
		final functions: Array<ChunkFunction> = [];
		final useFunctions: Array<ChunkFunction> = [];
		final chunkFields: Array<Field> = [];
		final constructorExpressions: Array<Expr> = [];
		final disuseExpressions: Array<Expr> = [];
		final synchronizeExpressions: Array<Expr> = [];

		for (i in 0...buildFields.length) {
			final buildField = buildFields[i];
			final buildFieldName = buildField.name;
			debug('Found field: ${buildFieldName}');

			final access = buildField.access;

			// TODO: metadata @:preserve

			switch buildField.kind {
				case FFun(func):
					if (access == null || !access.has(AStatic)) {
						debug('  Function that is not static. Skipping.');
						continue;
					}

					final returnType = func.ret;
					if (returnType != null && !unifyComplex(
						returnType,
						ComplexTypes.voidType
					)) {
						debug('  Function with return value. Skipping.');
						continue;
					}

					final useEntity = buildField.hasMetadata(":banker.useEntity");

					var documentation = buildField.doc;
					if (documentation == null) {
						documentation = if (useEntity)
							'Finds an entity that is currently available and marks it as in-use.';
						else
							'Iterates all entities that are currently in use.';
						documentation += '\n\nGenerated from function `$buildFieldName` in the original Structure class.';
					}

					final chunkFunction:ChunkFunction = {
						name: buildFieldName,
						arguments: func.args.copy(),
						expression: func.expr,
						documentation: documentation,
						position: buildField.pos
					};

					if (useEntity) {
						debug('  Found metadata: @:banker.useEntity');
						useFunctions.push(chunkFunction);
						debug('  Registered as a function for using new entity.');
					}
					else {
						functions.push(chunkFunction);
						debug('  Registered as a Chunk iterator.');
					}
				case FVar(varType, initialValue):
					if (varType == null) {
						warn('Type must be explicitly declared: ${buildFieldName}');
						continue;
					}

					final constructorExpression = createConstructorExpression(
						buildField,
						buildFieldName,
						initialValue
					);

					if (constructorExpression == null) {
						warn("Field must be initialized or have @:banker.factory metadata.");
						break;
					}

					constructorExpressions.push(constructorExpression);

					var documentation = buildField.doc;
					if (documentation == null)
						documentation = 'Vector generated from variable `$buildFieldName` in the original Structure class.';

					final vectorType = macro:banker.vector.WritableVector<$varType>;
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

					disuseExpressions.push(macro $i{chunkBufferFieldName}[i] = $i{chunkBufferFieldName}[nextWriteIndex]);

					variables.push({
						name: buildFieldName,
						type: varType,
						vectorType: vectorType
					});

					debug('  Converted to vector.');
				default:
					warn('Found field that is not a variable: ${buildFieldName}');
			}
		}

		final iterators: Array<ChunkMethod> = [];
		for (i in 0...functions.length) {
			final func = functions[i];
			debug('Create iterator: ${func.name}');

			final iterator = createIterator(func, variables, disuseExpressions);
			iterators.push(iterator);
			chunkFields.push(iterator.field);
		}

		final useMethods: Array<ChunkMethod> = [];
		for (i in 0...useFunctions.length) {
			final func = useFunctions[i];
			debug('Create use method: ${func.name}');

			final useMethod = createUse(func, variables);
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

	/**
		Generates expression pieces for creating iterate/use method from an user-defined function.
	**/
	static function generateMethodPieces(
		methodName: String,
		arguments: Array<FunctionArg>,
		variables: Array<ChunkVariable>
	) {
		final declareLocalVector: Array<Expr> = [];
		final declareLocalValue: Array<Expr> = [];
		final externalArguments: Array<FunctionArg> = [];
		var iArgumentIndex = -1;
		var needsWriteAccess = false;

		debug('  Scanning arguments.');
		for (k in 0...arguments.length) {
			final argument = arguments[k];
			final type = argument.type;

			if (argument.argumentIsWriteIndex()) {
				iArgumentIndex = k;
				debug('  - i ... Found index for write access.');
				continue;
			}

			if (argument.argumentIsDisuse()) {
				debug('  - disuse ... Found special variable for disusing entity.');
				continue;
			}

			var isVector = false;
			var associated = false;
			for (m in 0...variables.length) {
				final variable = variables[m];
				if (variable.name != argument.name) continue;

				if (unifyComplex(variable.type, argument.type)) {
					debug('  - ${argument.name} ... Found corresponding variable.');
					associated = true;
					break;
				}
				if (unifyComplex(variable.vectorType, argument.type)) {
					debug('  - ${argument.name} ... Found corresponding vector.');
					associated = true;
					isVector = true;
					needsWriteAccess = true;
					break;
				}
			}

			if (!associated) {
				debug('  - ${argument.name} ... No corresponding variable. Add to external arguments.');
				externalArguments.push(argument);
				continue;
			}

			final componentName = argument.name;

			if (isVector) {
				// provide WRITE access to the buffer via $componentName
				final writeVectorName = componentName + "ChunkBuffer";
				declareLocalVector.push(macro final $componentName = this.$writeVectorName);
			} else {
				// provide READ access to the current value via $componentName
				final localVectorName = componentName + "ChunkVector";
				final readVectorName = componentName;
				declareLocalVector.push(macro final $localVectorName = this.$readVectorName);
				declareLocalValue.push(macro final $componentName = $i{localVectorName}[i]);
			}
		}

		if (iArgumentIndex == -1 && needsWriteAccess)
			warn('Found vector argument but missing argument `i: Int` in function $methodName().');

		return {
			declareLocalValue: declareLocalValue,
			declareLocalVector: declareLocalVector,
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
	static function createIterator(
		originalFunction: ChunkFunction,
		variables: Array<ChunkVariable>,
		disuseExpressions: Array<Expr>
	): ChunkMethod {
		final pieces = generateMethodPieces(
			originalFunction.name,
			originalFunction.arguments,
			variables
		);
		final externalArguments = pieces.externalArguments;

		final initializeBeforeLoops: Array<Expr> = [];
		initializeBeforeLoops.pushFromArray(pieces.declareLocalVector);
		initializeBeforeLoops.push(macro final readWriteIndexMap = this.readWriteIndexMap);
		initializeBeforeLoops.push(macro final endReadIndex = this.endReadIndex);
		initializeBeforeLoops.push(macro var readIndex = 0);
		initializeBeforeLoops.push(macro var nextWriteIndex = this.nextWriteIndex);
		initializeBeforeLoops.push(macro var disuse = false);
		initializeBeforeLoops.push(macro var i = 0);

		final initializeLoop: Array<Expr> = [];
		initializeLoop.push(macro i = readWriteIndexMap[readIndex]);
		initializeLoop.pushFromArray(pieces.declareLocalValue);

		final finalizeLoop: Array<Expr> = [];
		finalizeLoop.push(macro ++readIndex);
		finalizeLoop.push(macro if (disuse) {
			--nextWriteIndex;
			$b{disuseExpressions};
			readWriteIndexMap[nextWriteIndex] = readIndex;
			disuse = false;
		});

		final finalizeAfterLoops: Array<Expr> = [];
		finalizeAfterLoops.push(macro this.nextWriteIndex = nextWriteIndex);

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
				declareLocalVector();
				final endReadIndex = this.endReadIndex;
				final readWriteIndexMap = this.readWriteIndexMap;
				var readIndex = 0;
				var nextWriteIndex = this.nextWriteIndex
				var disuse = false;
				var i: Int;

				while (readIndex < endReadIndex) {
					i = readWriteIndexMap[readIndex]; // write index
					declareLocalValue();

					originalFunction();

					++readIndex;
					if (disuse) {
						--nextWriteIndex;
						disuseExpr();
						readWriteIndexMap[nextWriteIndex] = readIndex;
						disuse = false;
					}
				}

				this.nextWriteIndex = nextWriteIndex

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
	static function createUse(
		originalFunction: ChunkFunction,
		variables: Array<ChunkVariable>
	): ChunkMethod {
		final pieces = generateMethodPieces(
			originalFunction.name,
			originalFunction.arguments,
			variables
		);
		final externalArguments = pieces.externalArguments;

		final expressions: Array<Expr> = [];
		expressions.push(macro final i = this.nextWriteIndex);
		expressions.pushFromArray(pieces.declareLocalVector);
		expressions.pushFromArray(pieces.declareLocalValue); // Not sure if it is necessary

		expressions.push(originalFunction.expression);

		expressions.push(macro final nextIndex = i + 1);
		expressions.push(macro this.nextWriteIndex = nextIndex);
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
				declareLocalVector();
				declareLocalValue();

				originalFunction();

				final nextIndex = i + 1;
				this.nextWriteIndex = nextIndex;
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
