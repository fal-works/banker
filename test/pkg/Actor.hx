package pkg;

import banker.vector.WritableVector as Vec;

// @:banker.verified
class Actor implements banker.aosoa.Structure {
	public static var staticInt: Int = 0;

	@:banker.chunkLevelFinal
	@:banker.chunkLevelFactory((chunkCapacity: Int) -> chunkCapacity)
	var chunkLevelFloat: Float;

	function onSynchronizeChunk() {
		staticInt = 0;
		println("synchronize chunk.");
	}

	static function sequenceNumbers(staticInt: Int) {
		println(staticInt);
		++staticInt;
	}

	static function onSynchronizeEntity() {
		println("synchronize entity.");
	}

	/** Prints position of all entities. **/
	static function print(x: Float, y: Float) {
		println('$x, $y');
	}

	static function disuseIf20(
		x: Float,
		y: Float,
		disuse: Bool
	) {
		if (x == 20) disuse = true;
	}

	@:banker.useEntity
	static function useEmpty() {}

	/** Use new entity. **/
	@:banker.useEntity
	static function use(
		x: Vec<Float>,
		y: Vec<Float>,
		newX: Float,
		newY: Float,
		i: Int
	) {
		x[i] = newX;
		y[i] = newY;
	}

	/** X position. **/
	var x: Float = 0;

	/** Y position. **/
	@:banker.factory(Math.random)
	var y: Float;

	@:banker.hidden
	var hidden: Int = 0;
}
