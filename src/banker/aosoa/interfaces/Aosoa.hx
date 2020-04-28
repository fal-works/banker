package banker.aosoa.interfaces;

/**
	Interface that can be used for AoSoA classes generated from `Structure` classes.

	Note that this is not automatically implemented.
**/
interface Aosoa {
	/**
		The capacity of each chunk i.e. the length of each vector that a chunk contains.
	**/
	public final chunkCapacity: UInt;

	/**
		The total number of entities in `this` AoSoA, i.e. (chunk capacity) * (chunk count).
	**/
	public final capacity: UInt;

	/**
		Reflects changes after the last synchronization.
	**/
	function synchronize(): Void;
}

// TODO: Make `Aosoa` generic so that it can have `chunks` and `getChunk()`?
