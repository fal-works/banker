package banker.binary;

enum abstract WordSize(UInt) {
	final Bit32 = 4;
	final Bit64 = 8;

	/**
		@return The size in bytes.
	**/
	public extern inline function bytes(): UInt
		return this;
}
