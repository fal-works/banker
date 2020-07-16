package banker.binary;

/**
	Size of word (a "word" is a data unit that can be stored in `ByteStack`).
**/
enum abstract WordSize(UInt) {
	final Bit32 = 4;
	final Bit64 = 8;

	/**
		@return The size in bytes.
	**/
	public extern inline function bytes(): UInt
		return this;
}
