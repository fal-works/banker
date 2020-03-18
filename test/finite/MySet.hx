package finite;

enum abstract Abc(Int) {
	/**
		This is A.
	**/
	final A;

	final B;
	final C;
}

@:build(banker.common.internal.finiteKeys.FiniteKeysCollection.build(Abc))
class MySet {}
