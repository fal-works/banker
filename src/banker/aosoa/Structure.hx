package banker.aosoa;

/**
	Marker interface indicating that the class is a structure from which an AoSoA
	(Array of Structure of Arrays) class is to be generated.

	By implementing this, the class will have a static method `createAosoa()`.
**/
@:autoBuild(banker.aosoa.macro.Builder.build())
interface Structure {}
