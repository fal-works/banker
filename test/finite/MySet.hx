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

@:banker.finite.initialValue(0)
@:build(banker.finite.FiniteKeys.from(Abc))
class MyMap {}

@:banker.finite.initialFactory((key: Abc) -> switch key { case A: 1; default: 2; })
@:build(banker.finite.FiniteKeys.from(Abc))
class MyMap2 {}
