package banker.binary.value_types;

/**
	Return value from pop operations of `ByteStackData`.

	As this class has `inline` constructor, a `PopReturn` instance...
	- must be directly assigned to a local variable, and
	- can be passed to or returned from a function only if it is inlined as well.
**/
#if !banker_generic_disable
@:generic
#end
class PopReturn2D<T> {
	/**
		Popped value.
	**/
	public final x: T;

	/**
		Popped value.
	**/
	public final y: T;

	/**
		Stack size after the pop operation.
	**/
	public final size: UInt;

	public extern inline function new(x: T, y: T, size: UInt) {
		this.x = x;
		this.y = y;
		this.size = size;
	}
}
