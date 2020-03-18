package finite;

import banker.container.FiniteKeysSet;

enum abstract Abc(Int) {
	/**
		This is A.
	**/
	final A;
	final B;
	final C;
}

@:banker.finiteKeys.enumAbstract(Abc)
class MySet implements FiniteKeysSet {}
