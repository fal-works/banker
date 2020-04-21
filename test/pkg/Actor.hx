package pkg;

import banker.vector.WritableVector as Vec;

// @:banker_verified
class Actor implements banker.aosoa.Structure {
	public static var staticInt: Int = 0;

	@:banker_chunkLevelFinal
	@:banker_chunkLevelFactory((chunkCapacity: UInt) -> chunkCapacity)
	var chunkLevelFloat: Float;

	@:banker_onSynchronize
	@:banker_chunkLevel
	function onSynchronizeChunk() {
		staticInt = 0;
		println("synchronize chunk.");
	}

	static function sequenceNumbers(staticInt: Int) {
		println(staticInt);
		++staticInt;
	}

	@:banker_onSynchronize
	static function onSynchronizeEntity() {
		println("synchronize entity.");
	}

	/** Prints position of all entities. **/
	static function print(x: Float, y: Float) {
		println('$x, $y');
	}

	static function printId(chunkId: UInt, entityId: UInt) {
		println('chunk $chunkId, entity $entityId');
	}

	static function disuseIf20(
		x: Float,
		y: Float,
		disuse: Bool
	) {
		if (x == 20) disuse = true;
	}

	@:banker_useEntity
	static function useEmpty() {}

	/** Use new entity. **/
	@:banker_useEntity
	static function use(
		x: Vec<Float>,
		y: Vec<Float>,
		newX: Float,
		newY: Float,
		i: UInt
	) {
		x[i] = newX;
		y[i] = newY;
	}

	/** X position. **/
	var x: Float = 0;

	/** Y position. **/
	@:banker_factory(Math.random)
	var y: Float;

	@:banker_hidden
	var hidden: Int = 0;
}
