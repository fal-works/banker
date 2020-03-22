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
	Value(expression: Expr, ?type: ComplexType);
	Function(name: String, ?returnType: ComplexType);
}
#end
