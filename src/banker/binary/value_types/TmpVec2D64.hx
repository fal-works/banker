package banker.binary.value_types;

/**
	2D vector of 64-bit float values.

	For temporal use only.
	The instance must be directly assigned to a local variable
	as this class has an `inline` constructor.
**/
@:structInit
class TmpVec2D64 {
	public final x: Float;
	public final y: Float;

	public extern inline function new(x: Float, y: Float) {
		this.x = x;
		this.y = y;
	}
}
