package banker.finite;

#if macro
/**
	Kind of initial value for each key.
	Either a value or a factory function.
**/
enum InitialValue {
	Value(expression: Expr, ?type: ComplexType);
	Function(name: String, ?returnType: ComplexType);
}
#end
