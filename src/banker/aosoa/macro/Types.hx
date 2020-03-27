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
#end
