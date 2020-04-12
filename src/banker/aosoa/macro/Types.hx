package banker.aosoa.macro;

#if macro
import haxe.macro.Expr;
import sneaker.types.Maybe;

typedef MetadataMap = {
	useEntity: Bool,
	onSynchronize: Bool,
	onCompleteSynchronize: Bool,
	factory: Maybe<Expr>,
	factoryWithId: Maybe<Expr>,
	externalFactory: Bool,
	readOnly: Bool,
	hidden: Bool,
	swap: Bool,
	chunkLevel: Bool,
	chunkLevelFinal: Bool,
	chunkLevelFactory: Maybe<Expr>
}

typedef FunctionField = {
	field: Field,
	func: Function
};

typedef VariableField = {
	field: Field,
	type: ComplexType,
	expression: Expr
}

/**
	Information about each variable of entity.
**/
typedef ChunkVariable = {
	name: String,
	type: ComplexType,
	vectorType: ComplexType,
	readOnly: Bool
};

/**
	Information about each function of entity.
**/
typedef ChunkFunction = {
	name: String,
	arguments: Array<FunctionArg>,
	expression: Expr,
	documentation: String,
	position: Position,
	kind: ChunkMethodKind
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
	constructorExternalArguments: Array<FunctionArg>,
	variables: Array<ChunkVariable>,
	iterators: Array<ChunkMethod>,
	useMethods: Array<ChunkMethod>
};

/**
	Kind of arguments in use/iterator methods.
**/
enum ArgumentKind {
	External;
	WriteIndex;
	Disuse;
	Read;
	Write;
	ChunkLevel(isStatic: Bool, isFinal: Bool);
}

/**
	Kind of chunk method, either use or iterator.
**/
enum ChunkMethodKind {
	/**
		Method that uses a new available entity.
	**/
	UseEntity;

	/**
		Method that iterates all entities that are currently in use.
	**/
	Iterate;

	/**
		Similar to `Iterate`, but automatically called in `synchronize()`.
	**/
	OnSynchronizeEntity(onComplete: Bool);
}

/**
	Initializing expression (and argument, if required) to be included in `new()`.
**/
enum ConstructorPiece {
	FromFactory(expression: Expr);
	FromArgument(expression: Expr, argument: FunctionArg);
}
#end
