package banker.binary;

/**
	Stack of bytes that can store values of 32-bit or 64-bit numeric types.
**/
class ByteStack {
	/**
		Creates a `ByteStack` instance.
		@param capacity The capacity of `this` stack in bytes.
	**/
	public static inline function alloc(capacity: UInt): ByteStack {
		return new ByteStack(capacity);
	}

	/**
		The capacity (in bytes) of `this` stack.
	**/
	public final capacity: UInt;

	/**
		The actual size (in bytes) of values in `this` stack.
	**/
	public var size(default, null): UInt;

	/**
		Data that contains stacked values.
	**/
	public final data: ByteStackData;

	/**
		Drops the top word.
	**/
	public extern inline function drop(wordSize: WordSize): Void
		this.size = this.data.drop(this.size, wordSize);

	/**
		Pops the top 32-bit word and returns it as an integer.
	**/
	public extern inline function popI32(): Int32 {
		final ret = this.data.popI32(this.size);
		this.size = ret.size;
		return ret.value;
	}

	/**
		Pops the top 64-bit word and returns it as an integer.
	**/
	public extern inline function popI64(): Int64 {
		final ret = this.data.popI64(this.size);
		this.size = ret.size;
		return ret.value;
	}

	/**
		Pops the top 32-bit word and returns it as a float.
	**/
	public extern inline function popF32(): Float32 {
		final ret = this.data.popF32(this.size);
		this.size = ret.size;
		return ret.value;
	}

	/**
		Pops the top 64-bit word and returns it as a float.
	**/
	public extern inline function popF64(): Float {
		final ret = this.data.popF64(this.size);
		this.size = ret.size;
		return ret.value;
	}

	/**
		Pushes a 32-bit integer.
	**/
	public extern inline function pushI32(value: Int32): Void
		this.size = this.data.pushI32(this.size, value);

	/**
		Pushes a 64-bit integer.
	**/
	public extern inline function pushI64(value: Int64): Void
		this.size = this.data.pushI64(this.size, value);

	/**
		Pushes a 32-bit float.
	**/
	public extern inline function pushF32(value: Float32): Void
		this.size = this.data.pushF32(this.size, value);

	/**
		Pushes a 64-bit float.
	**/
	public extern inline function pushF64(value: Float): Void
		this.size = this.data.pushF64(this.size, value);

	/**
		Returns the top 32-bit word as an integer without dropping it.
	**/
	public extern inline function peekI32(): Int32
		return this.data.peekI32(this.size);

	/**
		Returns the top 64-bit word as an integer without dropping it.
	**/
	public extern inline function peekI64(): Int64
		return this.data.peekI64(this.size);

	/**
		Returns the top 32-bit word as a float without dropping it.
	**/
	public extern inline function peekF32(): Float32
		return this.data.peekF32(this.size);

	/**
		Returns the top 64-bit word as a float without dropping it.
	**/
	public extern inline function peekF64(): Float
		return this.data.peekF64(this.size);

	/**
		Copies the top 32-bit word and pushes it to `this` stack.
	**/
	public extern inline function dup32(): Void
		this.size = this.data.dup32(this.size);

	/**
		Copies the top 64-bit word and pushes it to `this` stack.
	**/
	public extern inline function dup64(): Void
		this.size = this.data.dup64(this.size);

	/**
		Swaps the top and second-top 32-bit words.
	**/
	public extern inline function swap32(): Void
		this.data.swap32(this.size);

	/**
		Swaps the top and second-top 64-bit words.
	**/
	public extern inline function swap64(): Void
		this.data.swap64(this.size);

	/**
		Copies the second-top 32-bit word and pushes it to `this` stack.
	**/
	public extern inline function over32(topWordSize: WordSize): Void
		this.size = this.data.over32(this.size, topWordSize);

	/**
		Copies the second-top 64-bit word and pushes it to `this` stack.
	**/
	public extern inline function over64(topWordSize: WordSize): Void
		this.size = this.data.over64(this.size, topWordSize);

	/**
		Peeks the top 32-bit word as an integer and replaces it with an incremented value.
	**/
	public extern inline function increment32(): Void
		this.data.increment32(this.size);

	/**
		Peeks the top 64-bit word as an integer and replaces it with an incremented value.
	**/
	public extern inline function increment64(): Void
		this.data.increment64(this.size);

	/**
		Peeks the top 32-bit word as an integer and replaces it with an decremented value.
	**/
	public extern inline function decrement32(): Void
		this.data.decrement32(this.size);

	/**
		Peeks the top 64-bit word as an integer and replaces it with an decremented value.
	**/
	public extern inline function decrement64(): Void
		this.data.decrement64(this.size);

	/**
		@param separate `true` (default) to separate each byte with a space.
		@return `this` in hexadecimal representation.
	**/
	public extern inline function toHex(separate = true): String
		return this.data.toHex(this.size, separate);

	function new(capacity: UInt) {
		this.capacity = capacity;
		this.size = UInt.zero;
		this.data = ByteStackData.alloc(capacity);
	}
}
