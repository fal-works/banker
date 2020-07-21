package banker.binary;

import banker.binary.internal.Constants.*;

/**
	The data of `ByteStack`.
**/
abstract ByteStackData(BytesData) from BytesData to BytesData {
	/**
		Creates a `ByteStackData` instance.
		@param capacity The capacity of `this` stack in bytes.
	**/
	public static extern inline function alloc(capacity: UInt): ByteStackData
		return BytesData.alloc(capacity);

	/**
		Drops the top word.
		@return The stack size after operation.
	**/
	public extern inline function drop(stackSize: UInt, wordSize: WordSize): UInt
		return stackSize - wordSize.bytes();

	/**
		Drops the top two words.
		@return The stack size after operation.
	**/
	public extern inline function drop2D(stackSize: UInt, wordSize: WordSize): UInt
		return stackSize - wordSize.bytes() - wordSize.bytes();

	/**
		Pops the top 32-bit word.
		@return The popped `value` as integer and the stack `size` after operation.
		@see `PopReturn` (which should be directly assigned to a local variable)
	**/
	public extern inline function popI32(stackSize: UInt): PopReturn<Int32> {
		stackSize -= LEN32;
		return new PopReturn(this.getI32(stackSize), stackSize);
	}

	/**
		Pops the top 64-bit word.
		@return The popped `value` as integer and the stack `size` after operation.
		@see `PopReturn` (which should be directly assigned to a local variable)
	**/
	public extern inline function popI64(stackSize: UInt): PopReturn<Int64> {
		stackSize -= LEN64;
		return new PopReturn(this.getI64(stackSize), stackSize);
	}

	/**
		Pops the top 32-bit word.
		@return The popped `value` as float and the stack `size` after operation.
		@see `PopReturn` (which should be directly assigned to a local variable)
	**/
	public extern inline function popF32(stackSize: UInt): PopReturn<Float32> {
		stackSize -= LEN32;
		return new PopReturn(this.getF32(stackSize), stackSize);
	}

	/**
		Pops the top 64-bit word.
		@return The popped `value` as float and the stack `size` after operation.
		@see `PopReturn` (which should be directly assigned to a local variable)
	**/
	public extern inline function popF64(stackSize: UInt): PopReturn<Float> {
		stackSize -= LEN64;
		return new PopReturn(this.getF64(stackSize), stackSize);
	}

	/**
		Pops two 32-bit words from the top.
		@return The popped `x`/`y` as float and the stack `size` after operation.
		@see `PopReturn2D` (which should be directly assigned to a local variable)
	**/
	public extern inline function popVec2D32(stackSize: UInt): PopReturn2D<Float32> {
		stackSize -= LEN32 + LEN32;
		return new PopReturn2D(
			this.getF32(stackSize),
			this.getF32(stackSize + LEN32),
			stackSize
		);
	}

	/**
		Pops two 64-bit words from the top.
		@return The popped `x`/`y` as float and the stack `size` after operation.
		@see `PopReturn2D` (which should be directly assigned to a local variable)
	**/
	public extern inline function popVec2D64(stackSize: UInt): PopReturn2D<Float> {
		stackSize -= LEN64 + LEN64;
		return new PopReturn2D(
			this.getF64(stackSize),
			this.getF64(stackSize + LEN64),
			stackSize
		);
	}

	/**
		Pushes a 32-bit integer.
		@return The stack size after operation.
	**/
	public extern inline function pushI32(stackSize: UInt, v: Int32): UInt {
		this.setI32(stackSize, v);
		return stackSize + LEN32;
	}

	/**
		Pushes a 64-bit integer.
		@return The stack size after operation.
	**/
	public extern inline function pushI64(stackSize: UInt, v: Int64): UInt {
		this.setI64(stackSize, v);
		return stackSize + LEN64;
	}

	/**
		Pushes a 32-bit float.
		@return The stack size after operation.
	**/
	public extern inline function pushF32(stackSize: UInt, v: Float32): UInt {
		this.setF32(stackSize, v);
		return stackSize + LEN32;
	}

	/**
		Pushes a 64-bit float.
		@return The stack size after operation.
	**/
	public extern inline function pushF64(stackSize: UInt, v: Float): UInt {
		this.setF64(stackSize, v);
		return stackSize + LEN64;
	}

	/**
		Pushes two 64-bit float values.
		@return The stack size after operation.
	**/
	public extern inline function pushVec2D32(
		stackSize: UInt,
		x: Float32,
		y: Float32
	): UInt {
		this.setF32(stackSize, x);
		stackSize += LEN32;
		this.setF32(stackSize, y);
		stackSize += LEN32;
		return stackSize;
	}

	/**
		Pushes two 64-bit float values.
		@return The stack size after operation.
	**/
	public extern inline function pushVec2D64(
		stackSize: UInt,
		x: Float,
		y: Float
	): UInt {
		this.setF64(stackSize, x);
		stackSize += LEN64;
		this.setF64(stackSize, y);
		stackSize += LEN64;
		return stackSize;
	}

	/**
		Returns the top 32-bit word as an integer without dropping it.
	**/
	public extern inline function peekI32(stackSize: UInt): Int32
		return this.getI32(stackSize - LEN32);

	/**
		Returns the top 64-bit word as an integer without dropping it.
	**/
	public extern inline function peekI64(stackSize: UInt): Int64
		return this.getI64(stackSize - LEN64);

	/**
		Returns the top 32-bit word as a float without dropping it.
	**/
	public extern inline function peekF32(stackSize: UInt): Float
		return this.getF32(stackSize - LEN32);

	/**
		Returns the top 64-bit word as a float without dropping it.
	**/
	public extern inline function peekF64(stackSize: UInt): Float
		return this.getF64(stackSize - LEN64);

	/**
		Returns two 32-bit words from the top as float without dropping them.
	**/
	public extern inline function peekVec2D32(stackSize: UInt): TmpVec2D32 {
		return new TmpVec2D32(
			this.getF32(stackSize - LEN32 - LEN32),
			this.getF32(stackSize - LEN32)
		);
	}

	/**
		Returns two 64-bit words from the top as float without dropping them.
	**/
	public extern inline function peekVec2D64(stackSize: UInt): TmpVec2D64 {
		return new TmpVec2D64(
			this.getF64(stackSize - LEN64 - LEN64),
			this.getF64(stackSize - LEN64)
		);
	}

	/**
		Copies the top 32-bit word and pushes it to `this` stack.
		@return The stack size after operation.
	**/
	public extern inline function dup32(stackSize: UInt): UInt
		return pushI32(stackSize, peekI32(stackSize));

	/**
		Copies the top 64-bit word and pushes it to `this` stack.
		@return The stack size after operation.
	**/
	public extern inline function dup64(stackSize: UInt): UInt
		return pushF64(stackSize, peekF64(stackSize));

	/**
		Swaps the top and second-top 32-bit words.
	**/
	public function swap32(stackSize: UInt): Void {
		final pos1 = stackSize - LEN32;
		final pos2 = pos1 - LEN32;
		final tmp = this.getI32(pos1); // tmp < pos1
		this.setI32(pos1, this.getI32(pos2)); // pos1 < pos2
		this.setI32(pos2, tmp); // pos2 < tmp
	}

	/**
		Swaps the top and second-top 64-bit words.
	**/
	public function swap64(stackSize: UInt): Void {
		final pos1 = stackSize - LEN64;
		final pos2 = pos1 - LEN64;
		final tmp = this.getF64(pos1); // tmp < pos1
		this.setF64(pos1, this.getF64(pos2)); // pos1 < pos2
		this.setF64(pos2, tmp); // pos2 < tmp
	}

	/**
		Copies the second-top 32-bit word and pushes it to `this` stack.
		@return The stack size after operation.
	**/
	public extern inline function over32(stackSize: UInt, topWordSize: WordSize): UInt {
		return pushI32(
			stackSize,
			this.getI32(stackSize - topWordSize.bytes() - LEN32)
		);
	}

	/**
		Copies the second-top 64-bit word and pushes it to `this` stack.
		@return The stack size after operation.
	**/
	public extern inline function over64(stackSize: UInt, topWordSize: WordSize): UInt {
		return pushF64(
			stackSize,
			this.getF64(stackSize - topWordSize.bytes() - LEN64)
		);
	}

	/**
		Peeks the top 32-bit word as an integer and replaces it with an incremented value.
	**/
	public extern inline function increment32(stackSize: UInt): Void {
		final pos = stackSize - LEN32;
		this.setI32(pos, this.getI32(pos) + 1);
	}

	/**
		Peeks the top 64-bit word as an integer and replaces it with an incremented value.
	**/
	public extern inline function increment64(stackSize: UInt): Void {
		final pos = stackSize - LEN64;
		this.setI64(pos, this.getI64(pos) + 1);
	}

	/**
		Peeks the top 32-bit word as an integer and replaces it with an decremented value.
	**/
	public extern inline function decrement32(stackSize: UInt): Void {
		final pos = stackSize - LEN32;
		this.setI32(pos, this.getI32(pos) - 1);
	}

	/**
		Peeks the top 64-bit word as an integer and replaces it with an decremented value.
	**/
	public extern inline function decrement64(stackSize: UInt): Void {
		final pos = stackSize - LEN64;
		this.setI64(pos, this.getI64(pos) - 1);
	}

	/**
		@param separate `true` to separate each byte with a space.
		@return `this` in hexadecimal representation.
	**/
	public inline function toHex(length: UInt, separate: Bool)
		return this.toHex(length, separate);
}
