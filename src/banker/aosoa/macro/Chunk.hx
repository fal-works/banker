package banker.aosoa.macro;

#if macro
using Lambda;
using haxe.EnumTools;
using banker.aosoa.macro.FieldExtension;
using banker.aosoa.macro.MacroExtension;

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
	position: Position
}

typedef ChunkIterator = {
	field: Field,
	externalArguments: Array<FunctionArg>
};

/**
	Information about a Chunk class to be defined in any module.
**/
typedef ChunkDefinition = {
	typeDefinition: TypeDefinition,
	variables: Array<ChunkVariable>,
	iterators: Array<ChunkIterator>
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

		final chunkClassName = structureName + "Chunk";
		final chunkClass: TypeDefinition = macro class $chunkClassName {
			public function new(chunkSize: Int) {
				$b{prepared.constructorExpressions}
			}
		};
		chunkClass.fields = chunkClass.fields.concat(prepared.chunkFields);
		chunkClass.doc = 'Chunk (or SoA: Structure of Arrays) of `$structureName`.';
		chunkClass.pos = position;

		return {
			typeDefinition: chunkClass,
			variables: prepared.variables,
			iterators: prepared.iterators
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
		final thisField = macro $p{["this", buildFieldName]};

		return if (initialValue != null) {
			macro {
				$thisField = new banker.vector.WritableVector(chunkSize);
				$thisField.fill($initialValue);
			};
		} else {
			final factory = buildField.getFactory();
			if (factory == null) return null;

			macro {
				$thisField = new banker.vector.WritableVector(chunkSize);
				$thisField.populate($factory);
			}
		}
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
		var chunkFields: Array<Field> = [];
		final constructorExpressions: Array<Expr> = [];

		for (i in 0...buildFields.length) {
			final buildField = buildFields[i];
			final buildFieldName = buildField.name;
			debug('Found field: ${buildFieldName}');

			final access = buildField.access;

			// TODO: metadata @:preserve

			switch buildField.kind {
				case FFun(func):
					if (access == null || !access.has(AStatic) || func.ret != null) {
						debug('  Skipping.');
						continue;
					}

					functions.push({
						name: buildFieldName,
						arguments: func.args,
						expression: func.expr,
						position: buildField.pos
					});
					debug('  Registered as an chunk-iterator.');
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

					if (constructorExpression != null) {
						final vectorType = macro:banker.vector.WritableVector<$varType>;
						chunkFields.push(buildField.setVariableType(vectorType).addAccess(AFinal));
						constructorExpressions.push(constructorExpression);
						variables.push({
							name: buildFieldName,
							type: varType,
							vectorType: vectorType
						});
						debug('  Converted to vector.');
					} else
						warn("Field must be initialized or have @:banker.factory metadata.");
				default:
					warn('Found field that is not a variable: ${buildFieldName}');
			}
		}

		final iterators: Array<ChunkIterator> = [];
		for (i in 0...functions.length) {
			final func = functions[i];
			debug('Create iterator: ${func.name}');

			final iterator = createIterator(func, variables);
			iterators.push(iterator);
			chunkFields.push(iterator.field);
			debug('  Created.');
		}

		return {
			variables: variables,
			functions: functions,
			chunkFields: chunkFields,
			constructorExpressions: constructorExpressions,
			iterators: iterators
		};
	}

	static function createIterator(
		func: ChunkFunction,
		variables: Array<ChunkVariable>
	): ChunkIterator {
		final arguments = func.arguments;
		final outsideLoopLocalVariables: Array<Expr> = [];
		final insideLoopLocalVariables: Array<Expr> = [];
		final externalArguments: Array<FunctionArg> = [];
		var documentation = "dummy";

		debug('Scanning arguments.');
		for (k in 0...arguments.length) {
			final argument = arguments[k];
			final type = argument.type;

			var isVector = false;
			var associated = false;
			for (m in 0...variables.length) {
				final variable = variables[m];
				if (variable.name != argument.name) continue;

				if (variable.type.compareComplexType(argument.type)) {
					debug('- ${argument.name} ... Found corresponding variable.');
					associated = true;
					break;
				}
				if (variable.vectorType.compareComplexType(argument.type)) {
					debug('- ${argument.name} ... Found corresponding vector.');
					associated = true;
					isVector = true;
					break;
				}
				debug('- ${argument.name} ... No corresponding variable. Add to external arguments.');
				externalArguments.push(argument);
			}

			if (!associated) continue;

			final variableName = argument.name;

			if (isVector) {
				outsideLoopLocalVariables.push(macro final $variableName = this.$variableName);
			} else {
				final vectorName = variableName + "ChunkVector";
				outsideLoopLocalVariables.push(macro final $vectorName = this.$variableName);
				insideLoopLocalVariables.push(macro final $variableName = $i{vectorName}[i]);
			}
		}

		final loopBodyExpressions = insideLoopLocalVariables.concat([
			func.expression,
			macro ++i,
		]);

		final indexInitialization = macro var i = 0;
		final loopStatement = macro while (i < endIndex) $b{loopBodyExpressions};

		final wholeExpressions = outsideLoopLocalVariables.concat([
			indexInitialization,
			loopStatement
		]);

		final iterator: Function = {
			args: externalArguments.concat([{ name: "endIndex", type: (macro:Int) }]),
			ret: null,
			expr: macro $b{wholeExpressions}
		};

		// This will generate something like the below:
		/*
			function someIterator(externalArgs, endIndex: Int) {
				declare(outsideLoopLocalVariables);
				var i = 0;
				while (i < endIndex) {
					declare(insideLoopLocalVariables);
					run(func.expression);
					++i;
				}
			}
		*/

		final field: Field = {
			name: func.name,
			kind: FFun(iterator),
			pos: func.position,
			doc: documentation,
			access: [APublic, AInline]
		};

		final iterator: ChunkIterator = {
			field: field,
			externalArguments: externalArguments
		};
		return iterator;
	}
}
#end
