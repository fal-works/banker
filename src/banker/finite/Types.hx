package banker.finite;

#if macro
/**
	Initial value for each key.
**/
typedef InitialValue = {
	kind: InitialValueKind,
	type: ComplexType
};

/**
	Kind of initial value for each key.
	Either a value or a factory function.
**/
enum InitialValueKind {
	Value(expression: Expr);
	Function(name: String);
}

/**
	Types of key and value for the building class.
**/
typedef KeyValueTypes = {
	key: {
		expression: Expr, type: Type, complex: ComplexType
	},
	value: {
		type: Type, complex: ComplexType
	}
}
#end
