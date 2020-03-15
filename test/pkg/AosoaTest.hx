package pkg;

import banker.vector.WritableVector as Vec;

class Actor implements banker.aosoa.Structure {
	/** Prints position of all entities. **/
	static function print(x: Float, y: Float) {
		println('$x, $y');
	}

	/** Use new entity. **/
	@:banker.useEntity
	static function use(
		x: Vec<Float>,
		y: Vec<Float>,
		newX: Float,
		newY: Float
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

@:access(pkg.Actor, pkg.ActorChunk)
class AosoaTest {
	static function basic() {
		describe("This goes without error.");
		final actorAosoa = new Actor(2, 3);
		final firstChunk = actorAosoa.chunks[0];
		final x = firstChunk.x[0];
		final y = firstChunk.y[0];
		assert(x == 0);
		assert(y >= 0 && y <= 1);
	}

	static final _basic = testCase(basic, Ok);

	static function iterate() {
		describe("This prints 6 lines of position infos.");
		final actorAosoa = new Actor(2, 3);
		actorAosoa.print();
	}

	static final _iterate = testCase(iterate, Visual);

	static function use() {
		describe("This goes without error.");
		final actorAosoa = new Actor(2, 3);
		actorAosoa.use(10, 20);
		final chunk = actorAosoa.chunks[0];
		actorAosoa.synchronize();
		assert(chunk.x[0] == 10);
		assert(chunk.y[0] == 20);
	}

	static final _use = testCase(use, Ok);

	public static final all = testCaseGroup([
		_basic,
		_iterate,
		_use
	]);
}
