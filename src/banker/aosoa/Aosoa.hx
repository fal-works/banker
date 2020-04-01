package banker.aosoa;

#if macro
import haxe.macro.Expr;
import banker.aosoa.macro.Builder;

class Aosoa {
	/**
		The entry point of build macro for AoSoA classes.
		@param chunkTypeExpression Any class built with `banker.aosoa.Chunk.fromStructure()`.
	**/
	public static macro function fromChunk(chunkTypeExpression: Expr): Null<Array<Field>> {
		return Builder.aosoaFromChunk(chunkTypeExpression);
	}
}
#else
class Aosoa{}
#end
