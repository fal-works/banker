package pkg;

class Actor implements banker.aosoa.Structure {
	static function print(x: Float, y: Float) {
		println('$x, $y');
	}

	var x: Float = 0;

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

	public static final all = testCaseGroup([
		_basic,
		_iterate
	]);
}
