package banker.aosoa.macro;

#if macro
using Lambda;
using haxe.EnumTools;
using sneaker.macro.FieldExtension;
using banker.array.ArrayExtension;
using banker.aosoa.macro.FieldExtension;
using banker.aosoa.macro.MacroExtension;

import haxe.macro.Context;
import banker.aosoa.macro.MacroTypes;

/**
	Information about each variable of entity.
**/
typedef ChunkVariable = {
	name: String,
	type: ComplexType,
	vectorType: ComplexType
};

typedef ChunkFunction = {
	name: String,
	arguments: Array<FunctionArg>,
	expression: Expr,
	documentation: String,
	position: Position
}

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

/**
	Information about a Chunk class defined in any module.
**/
typedef ChunkType = {
	path: TypePath,
	pathString: String
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
			public var endReadIndex = 0;
			public var nextWriteIndex = 0;

			public function new(chunkSize: Int) {
				$b{prepared.constructorExpressions};
			}

			public function synchronize() {
				final nextWriteIndex = this.nextWriteIndex;
				$b{prepared.synchronizeExpressions};
				this.endReadIndex = nextWriteIndex;
			}
		};
		chunkClass.fields = chunkClass.fields.concat(prepared.chunkFields);
		chunkClass.doc = 'Chunk (or SoA: Structure of Arrays) of `$structureName`.';
		chunkClass.pos = position;

		return {
			typeDefinition: chunkClass,
			variables: prepared.variables,
			iterators: prepared.iterators,
			useMethods: prepared.useMethods
		};
	}

	/**
		Defines a Chunk class as a sub-type in the local module.
		@return `path`: TypePath of the class. `pathString`: Dot-separated path of the class.
	**/
	public static function define(chunkDefinition: TypeDefinition): ChunkType {
		final localModule = MacroTools.getLocalModuleInfo();
		chunkDefinition.pack = localModule.packages;
		MacroTools.defineSubType([chunkDefinition]);

		final subTypeName = chunkDefinition.name;

		return {
			path: {
				pack: localModule.packages,
				name: localModule.name,
				sub: subTypeName
			},
			pathString: '${localModule.path}.${subTypeName}'
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
		var chunkFields: Array<Field> = [];
		final constructorExpressions: Array<Expr> = [];
		final disuseExpressions: Array<Expr> = []; // not yet used
		final synchronizeExpressions: Array<Expr> = []; // not yet used

		for (i in 0...buildFields.length) {
			final buildField = buildFields[i];
			final buildFieldName = buildField.name;
			debug('Found field: ${buildFieldName}');

			final access = buildField.access;

			// TODO: metadata @:preserve

			switch buildField.kind {
				case FFun(func):
					// Must be static and have no return value
					if (access == null || !access.has(AStatic) || func.ret != null) {
						debug('  Skipping.');
						continue;
					}

					final func:ChunkFunction = {
						name: buildFieldName,
						arguments: func.args,
						expression: func.expr,
						documentation: buildField.doc,
						position: buildField.pos
					};

					if (buildField.hasMetadata(":banker.useEntity")) {
						debug('  Found metadata: @:banker.useEntity');
						useFunctions.push(func);
						debug('  Registered as a function for using new entity.');
					}
					else {
						functions.push(func);
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

					final vectorType = macro:banker.vector.WritableVector<$varType>;
					final chunkField = buildField.setVariableType(vectorType).addAccess(AFinal);
					chunkFields.push(chunkField);

					final chunkBufferFieldName = buildFieldName + "ChunkBuffer";
					final chunkBufferField = chunkField.clone().setName(chunkBufferFieldName);

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
		arguments: Array<FunctionArg>,
		variables: Array<ChunkVariable>
	) {
		final declareLocalVector: Array<Expr> = [];
		final declareLocalValue: Array<Expr> = [];
		final externalArguments: Array<FunctionArg> = [];

		debug('  Scanning arguments.');
		for (k in 0...arguments.length) {
			final argument = arguments[k];
			final type = argument.type;

			var isVector = false;
			var associated = false;
			for (m in 0...variables.length) {
				final variable = variables[m];
				if (variable.name != argument.name) continue;

				if (variable.type.unifyComplex(argument.type)) {
					debug('  - ${argument.name} ... Found corresponding variable.');
					associated = true;
					break;
				}
				if (variable.vectorType.unifyComplex(argument.type)) {
					debug('  - ${argument.name} ... Found corresponding vector.');
					associated = true;
					isVector = true;
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

		return {
			declareLocalValue: declareLocalValue,
			declareLocalVector: declareLocalVector,
			externalArguments: externalArguments
		};
	}

	static function createMethod(
		originalFunction: ChunkFunction,
		builtFunction: Function,
		externalArguments: Array<FunctionArg>
	) {
		final field: Field = {
			name: originalFunction.name,
			kind: FFun(builtFunction),
			pos: originalFunction.position,
			doc: originalFunction.documentation,
			access: [APublic, AInline]
		};

		final method: ChunkMethod = {
			field: field,
			externalArguments: externalArguments
		};
		return method;
	}

	static function createIterator(
		func: ChunkFunction,
		variables: Array<ChunkVariable>,
		disuseExpressions: Array<Expr>
	): ChunkMethod {
		final pieces = generateMethodPieces(func.arguments, variables);
		final externalArguments = pieces.externalArguments;

		final initializeBeforeLoops = pieces.declareLocalVector.copy();
		initializeBeforeLoops.push(macro final endReadIndex = this.endReadIndex);
		initializeBeforeLoops.push(macro var nextWriteIndex = this.nextWriteIndex);
		initializeBeforeLoops.push(macro var disuse: Bool);
		initializeBeforeLoops.push(macro var i = 0);

		final initializeLoop = pieces.declareLocalValue.copy();
		initializeLoop.push(macro disuse = false);

		final finalizeLoop: Array<Expr> = [];
		finalizeLoop.push(macro ++i);
		finalizeLoop.push(macro if (disuse) {
			$b{disuseExpressions};
			--nextWriteIndex;
			disuse = false;
		});

		final finalizeAfterLoops: Array<Expr> = [];
		finalizeAfterLoops.push(macro this.nextWriteIndex = nextWriteIndex);

		final loopBodyExpressions = [
			initializeLoop,
			[func.expression],
			finalizeLoop
		].flatten();

		final loopStatement = macro while (i < endReadIndex) $b{loopBodyExpressions};

		final wholeExpressions = [
			initializeBeforeLoops,
			[loopStatement],
			finalizeAfterLoops
		].flatten();

		final iterator: Function = {
			args: externalArguments,
			ret: null,
			expr: macro $b{wholeExpressions}
		};

		// This will generate something like the below:
		/*
			function someIterator(externalArgs) {
				declareLocalVector();
				final endReadIndex = this.endReadIndex;
				var disuse: Bool;
				var i = 0;
				while (i < endReadIndex) {
					declareLocalValue();
					func();
					++i;
					if (disuse) {
						disuseExpr();
						disuse = false;
					}
				}
			}
		**/

		return createMethod(func, iterator, externalArguments);
	}

	static function createUse(
		func: ChunkFunction,
		variables: Array<ChunkVariable>
	): ChunkMethod {
		final pieces = generateMethodPieces(func.arguments, variables);
		final externalArguments = pieces.externalArguments;

		final expressions: Array<Expr> = [];
		expressions.push(macro final i = this.nextWriteIndex);
		expressions.pushFromArray(pieces.declareLocalVector);
		expressions.pushFromArray(pieces.declareLocalValue); // Not sure if it is necessary
		expressions.push(func.expression);
		expressions.push(macro final nextWriteIndex = i + 1);
		expressions.push(macro this.nextWriteIndex = nextWriteIndex);
		expressions.push(macro return nextWriteIndex);

		final iterator: Function = {
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
				func();
				this.nextWriteIndex = i;
			}
		**/

		return createMethod(func, iterator, externalArguments);
	}
}
#end
