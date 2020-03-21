package banker.finite;

#if macro
enum KeyType {
	Some(type: EnumAbstractType);
	None;
	TooMany;
}

/**
	Kind of initial value for each key.
	Either a value or a factory function.
**/
enum InitialValue {
	Value(expression: Expr, ?type: ComplexType);
	Function(name: String, ?returnType: ComplexType);
}
#end
