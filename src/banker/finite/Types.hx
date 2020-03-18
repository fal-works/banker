package banker.finite;

#if macro
enum KeyType {
	Some(type: EnumAbstractType);
	None;
	TooMany;
}

enum DefaultValue {
	Value(v: Expr);
	Function(func: Expr);
}
#end
