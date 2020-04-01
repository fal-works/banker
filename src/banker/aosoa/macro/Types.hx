package banker.aosoa.macro;

#if macro
import haxe.ds.Option;
import haxe.macro.Expr;

typedef MetadataMap = {
	useEntity: Bool,
	factory: Option<Expr>,
	hidden: Bool,
	swap: Bool,
	chunkLevel: Bool,
	chunkLevelFinal: Bool,
	chunkLevelFactory: Option<Expr>,
	onSynchronize: Bool
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
	UseEntity;
	Iterate;
}

/**
	Initializing expression (and argument, if required) to be included in `new()`.
**/
enum ConstructorPiece {
	FromFactory(expression: Expr);
	FromArgument(expression: Expr, argument: FunctionArg);
}
#end
