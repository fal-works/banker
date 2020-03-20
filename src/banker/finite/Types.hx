package banker.finite;

#if macro
enum KeyType {
	Some(type: EnumAbstractType);
	None;
	TooMany;
}

enum InitialValue {
	Value(expression: Expr, type: ComplexType);
	Function(expression: Expr, returnType: ComplexType);
}
#end
