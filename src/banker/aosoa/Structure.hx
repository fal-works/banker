package banker.aosoa;

/**
	Marker interface indicating that the class is a structure from which an AoSoA
	(Array of Structure of Arrays) class is to be generated.
**/
@:autoBuild(banker.aosoa.macro.Builder.structure())
interface Structure {}
