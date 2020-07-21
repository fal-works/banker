package banker.binary;

/**
	2D vector of 32-bit float values.

	For temporal use only.
	The instance must be directly assigned to a local variable
	as this class has an `inline` constructor.
**/
@:structInit
class TmpVec2D32 {
	public final x: Float32;
	public final y: Float32;

	public extern inline function new(x: Float32, y: Float32) {
		this.x = x;
		this.y = y;
	}
}
