package banker.aosoa;

#if macro
import haxe.macro.Expr;
import banker.aosoa.macro.Builder;

class Chunk {
	/**
		The entry point of build macro for Chunk classes.
		@param structureTypeExpression Any class that implements `banker.aosoa.Structure`.
	**/
	public static macro function fromStructure(structureTypeExpression: Expr): Null<Array<Field>> {
		return Builder.chunkFromStructure(structureTypeExpression);
	}
}
#else
class Chunk{}
#end
