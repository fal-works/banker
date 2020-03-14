package banker.aosoa;

/**
	Marker interface indicating that the class is to be rebuilt to an AoSoA
	(Array of Structure of Arrays) class.

	By implementing this,
	- All variables are converted to a vector, which constitute a "Chunk" of entities.
	- The class implementing `Structure` will consist of multiple "Chunk"s.
	- The following fields are added.
		- `chunks`: Vector of "Chunk"s of which the whole AoSoA consists.
		- `chunkSize`: Number of elements that a Chunk contains.
		- `chunkCount`: Number of Chunks.
		- `iterate()`: Iterates all entities.
**/
@:autoBuild(banker.aosoa.macro.BuildMacro.build())
interface Structure {}
