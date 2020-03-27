package banker.aosoa.macro;

#if macro
import haxe.macro.Expr;

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
	variables: Array<ChunkVariable>,
	iterators: Array<ChunkMethod>,
	useMethods: Array<ChunkMethod>
};

enum ArgumentKind {
	External;
	WriteIndex;
	Disuse;
	Read;
	Write;
	ChunkLevel(isStatic: Bool, isFinal: Bool);
}
#end
