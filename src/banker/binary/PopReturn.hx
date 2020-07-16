package banker.binary;

/**
	Return value from pop operations of `ByteStackData`.
**/
#if !banker_generic_disable
@:generic
#end
class PopReturn<T> {
	/**
		Popped value.
	**/
	public final value: T;

	/**
		Byte position in the stack after the pop operation.
	**/
	public final pos: UInt;

	public extern inline function new(value: T, pos: UInt) {
		this.value = value;
		this.pos = pos;
	}
}
