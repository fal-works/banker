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
