package banker.aosoa.macro;

#if macro
using Lambda;
using banker.aosoa.macro.FieldExtension;

import banker.aosoa.macro.MacroTypes;

/**
	Information about each variable of entity.
**/
typedef ChunkVariable = {
	name: String,
	type: ComplexType
};

typedef ChunkFunction = {
	name: String,
	callArguments: Array<ComplexType>
}

/**
	Information about a Chunk class to be defined in any module.
**/
typedef ChunkDefinition = {
	typeDefinition: TypeDefinition,
	variables: Array<ChunkVariable>,
	iterateCallbackType: ComplexType
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

		final customIterators = createCustomIterators(prepared.functions, prepared.variables, position);
		chunkClass.fields = chunkClass.fields.concat(customIterators.map(iterator -> iterator.field));

		final iterate = createIterationMethod(prepared.variables, position);
		chunkClass.fields.push(iterate.field);

		return {
			typeDefinition: chunkClass,
			variables: prepared.variables,
			iterateCallbackType: iterate.callbackType
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
		final functions: Array<Function> = [];
		final chunkFields: Array<Field> = [];
		final constructorExpressions: Array<Expr> = [];

		for (i in 0...buildFields.length) {
			final buildField = buildFields[i];
			final buildFieldName = buildField.name;
			debug('Found field: ${buildFieldName}');

			if (buildFieldName == "iterate") {
				warn('Field name `iterate` is reserved. Please use another name.');
				continue;
			}

			final access = buildField.access;

			// TODO: metadata @:preserve

			switch buildField.kind {
				case FFun(func):
					if (access != null && access.has(AStatic) && func.ret == null && func.expr != null && func.params == null) {
						final arguments = func.args;
						if (arguments.length > 0) functions.push(func);
					}
					debug('  Registered as a candidate of iterating functions.');
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
							type: varType
						});
						debug('  Converted to vector.');
					} else
						warn("Field must be initialized or have @:banker.factory metadata.");
				default:
					warn('Found field that is not a variable: ${buildFieldName}');
			}
		}

		return {
			variables: variables,
			functions: functions,
			chunkFields: chunkFields,
			constructorExpressions: constructorExpressions
		};
	}

	static function createCustomIterator(func: Function, variables: Array<ChunkVariable>, position: Position) {
		final arguments = func.args;
		final embeddedArguments: Array<FunctionArg> = [];
		final localVariableDeclarations: Array<Expr> = [];
		final callArguments: Array<Expr> = [];
		var documentation = "dummy";

		for (k in 0...arguments.length) {
			final argument = arguments[k];
			final type = argument.type;
			if (type == null) continue;
			if (!variables.exists(variable -> variable.name == argument.name && variable.type == type))
				continue;

			final variableName = argument.name;
			embeddedArguments.push(argument);
			localVariableDeclarations.push(macro final $variableName = this.$variableName);
			callArguments.push(macro $i{variableName}[i]);
		}

		if (embeddedArguments.length == 0) return null;

		final callbackType = TFunction([], (macro:Void));
		final iterator: Function = {
			args: [
				{ name: "callback", type: callbackType },
				{ name: "endIndex", type: (macro:Int) }
			],
			ret: null,
			expr: macro {
				$b{localVariableDeclarations};
				var i = 0;
				while (i < endIndex) {
					callback($a{callArguments});
					++i;
				}
			}
		};


		final field: Field = {
			name: "iterate",
			kind: FFun(iterator),
			pos: position,
			doc: documentation,
			access: [APublic, AInline]
		};

		return {
			field: field,
			callbackType: callbackType
		};
	}

	static function createCustomIterators(functions: Array<Function>, variables: Array<ChunkVariable>, position: Position) {
		final iterators = [];
		for (i in 0...functions.length) {
			final iterator = createCustomIterator(functions[i], variables, position);
			if (iterator != null) iterators.push(iterator);
		}

		return iterators;
	}

	/**
		Creates `iterate()` method for adding to the Chunk class.
	**/
	static function createIterationMethod(variables: Array<ChunkVariable>, position: Position) {
		final callArgumentTypes: Array<ComplexType> = [];
		final localVariableDeclarations: Array<Expr> = [];
		final callArguments: Array<Expr> = [];
		var documentation = "Runs `callback()` for each entity in this chunk.\n";

		for (i in 0...variables.length) {
			final variable = variables[i];
			final variableName = variable.name;

			callArgumentTypes.push(TNamed(variableName, variable.type));
			localVariableDeclarations.push(macro final $variableName = this.$variableName);
			callArguments.push(macro $i{variableName}[i]);
			documentation += '\n@param ${variableName}';
		}

		final callbackType = TFunction(callArgumentTypes, (macro:Void));

		final iterateFunction: Function = {
			args: [
				{ name: "callback", type: callbackType },
				{ name: "endIndex", type: (macro:Int) }
			],
			ret: null,
			expr: macro {
				$b{localVariableDeclarations};
				var i = 0;
				while (i < endIndex) {
					callback($a{callArguments});
					++i;
				}
			}
		};

		final field: Field = {
			name: "iterate",
			kind: FFun(iterateFunction),
			pos: position,
			doc: documentation,
			access: [APublic, AInline]
		};

		return {
			field: field,
			callbackType: callbackType
		};
	}
}
#end
