package banker.aosoa.interfaces;

/**
	Type for constructing AoSoA.

	Usage example:

	```haxe
	@:generic
	static function createAosoa<T:AosoaConstructible>():T {
		final chunkCapacity = 64;
		final chunkCount = 16;
		final aosoa = new T(chunkCapacity, chunkCount);
		return aosoa;
	}

	static function main() {
		final aosoa: MyAosoaClass = createAosoa();
	}
	```
**/
typedef AosoaConstructible = haxe.Constraints.Constructible<(
	chunkCapacity: UInt,
	chunkCount: UInt
) -> Void>;
