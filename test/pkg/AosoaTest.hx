package pkg;

import sneaker.print.Printer;
import banker.vector.WritableVector as Vec;

class Actor implements banker.aosoa.Structure {
	/** Prints position of all entities. **/
	static function print(x: Float, y: Float) {
		println('$x, $y');
	}

	static function disuseIf20(x: Float, y: Float, disuse: Bool) {
		if (x == 20) disuse = true;
	}

	public function new() {}

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

@:access(pkg.Actor, pkg.ActorChunk)
class AosoaTest {
	static function basic() {
		describe("This goes without error.");
		final actorAosoa = Actor.createAosoa(2, 3);
		final firstChunk = actorAosoa.chunks[0];
		final x = firstChunk.x[0];
		final y = firstChunk.y[0];
		assert(x == 0);
		assert(y >= 0 && y <= 1);
	}

	static final _basic = testCase(basic, Ok);

	static function iterate() {
		describe("This prints 5 lines of position infos.");
		final actorAosoa = Actor.createAosoa(2, 3);
		for (i in 0...5) actorAosoa.useEmpty();
		actorAosoa.synchronize();
		actorAosoa.print();
	}

	static final _iterate = testCase(iterate, Visual);

	static function use() {
		describe("This goes without error.");
		final actorAosoa = Actor.createAosoa(2, 3);
		actorAosoa.use(10, 20);
		final chunk = actorAosoa.chunks[0];
		actorAosoa.synchronize();
		assert(chunk.x[0] == 10);
		assert(chunk.y[0] == 20);
		actorAosoa.print();
		assert(Printer.lastBuffered == "10, 20");
	}

	static final _use = testCase(use, Ok);

	static function disuse() {
		describe("This prints: 10, 40, 30, 50");
		final actorAosoa = Actor.createAosoa(4, 2);

		actorAosoa.use(10, 10);
		actorAosoa.use(20, 20); // will be removed
		actorAosoa.use(30, 30);
		actorAosoa.use(40, 40); // will move to index 1

		actorAosoa.use(50, 50);

		actorAosoa.synchronize();
		actorAosoa.disuseIf20();
		actorAosoa.synchronize();
		actorAosoa.print();
	}

	static final _disuse = testCase(disuse, Visual);

	public static final all = testCaseGroup([
		_basic,
		_iterate,
		_use,
		_disuse
	]);
}
