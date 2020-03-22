package finite;

// @:banker.verified
@:build(banker.finite.FiniteKeys.from(Abc))
class MySet {}

// @:banker.verified
@:build(banker.finite.FiniteKeys.from(Abc))
class MyMap {
	static final initialValue: Int = 0;
}

// @:banker.verified
@:build(banker.finite.FiniteKeys.from(Abc))
class MyMap2 implements banker.finite.interfaces.FiniteKeysMap<finite.Abc, Int> {
	static function initialValue(key: Abc): Int {
		return switch key {
			case A: 1;
			default: 2;
		};
	}
}
