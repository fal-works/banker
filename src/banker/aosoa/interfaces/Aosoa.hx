package banker.aosoa.interfaces;

/**
	Interface that can be used for AoSoA classes generated from `Structure` classes.

	Note that this is not automatically implemented.
**/
interface Aosoa {
	/**
		Reflects changes after the last synchronization.
	**/
	function synchronize(): Void;
}
