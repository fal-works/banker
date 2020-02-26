package banker.ds;

import banker.ds.Vector.VectorData;

class VectorTools {
	// ---- constructor functions -----------------------------------------------

	/**
	 * Casts from `VectorData<T>` to `Vector<T>`.
	 */
	public static inline function fromData<T>(data:VectorData<T>):Vector<T>
		return cast data;

	/**
	 * Creates a new Vector by shallow-copying the elements of `array`.
	 */
	public static inline function fromArrayCopy<T>(array:Array<T>):Vector<T> {
		return fromData(VectorData.fromArrayCopy(unwrap(array)));
	}

	/**
	 * Creates a vector filled with the given value.
	 */
	public static inline function createFilled<T>(length:Int, fillValue:T):Vector<T>
		return fromData(new Vector<T>(length).data.fill(fillValue));

	/**
	 * Creates a vector populated using the given factory function.
	 */
	public static inline function createPopulated<T>(length:Int, factory:Void->T):Vector<T>
		return fromData(new Vector<T>(length).data.populate(factory));

	// ---- write functions -----------------------------------------------------

	/**
	 * Copies `rangeLength` of elements from `source` (beginning at `sourcePosition`)
	 * to `destination` (beginning at `destinationPosition`).
	 */
	public static inline function blit<T>(source:Vector<T>, sourcePosition:Int, destination:WritableVector<T>, destinationPosition:Int, rangeLength:Int):Void
		VectorData.blit(source.data, sourcePosition, destination.data, destinationPosition, rangeLength);

	/**
	 * Blits data from vector to array.
	 */
	public static inline function blitToArray<T>(sourceVector:Vector<T>, sourcePosition:Int, destinationArray:Array<T>, destinationPosition:Int,
			rangeLength:Int):Void {
		var i = 0;
		while (i < rangeLength) {
			destinationArray[destinationPosition + i] = sourceVector[sourcePosition + i];
			++i;
		}
	}
}
