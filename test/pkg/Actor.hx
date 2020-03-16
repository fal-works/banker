package pkg;

import banker.vector.WritableVector as Vec;

class Actor implements banker.aosoa.Structure {
	/** Prints position of all entities. **/
	static function print(x: Float, y: Float) {
		println('$x, $y');
	}

	static function disuseIf20(x: Float, y: Float, disuse: Bool) {
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
}
