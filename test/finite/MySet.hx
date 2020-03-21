package finite;

enum abstract Abc(Int) {
	/**
		This is A.
	**/
	final A;

	final B;
	final C;
}

@:build(banker.finite.FiniteKeys.from(Abc))
class MySet {}

@:build(banker.finite.FiniteKeys.from(Abc))
class MyMap {
	static final initialValue = 0;
}

@:build(banker.finite.FiniteKeys.from(Abc))
class MyMap2 {
	static function initialValue(key: Abc): Int {
		return switch key {
			case A: 1;
			default: 2;
		};
	}
}
