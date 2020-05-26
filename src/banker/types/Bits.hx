package banker.types;

import sneaker.string_buffer.StringBuffer;

/**
	Bit array based on `Int`.
**/
abstract Bits(Int) {
	public static extern inline final zero = Bits.from(0);
	public static extern inline final one = Bits.from(1);

	/**
		Casts `Int` to `Bits`.
	**/
	public static extern inline function from(v: Int): Bits
		return new Bits(v);

	@:op(A << B)
	public static extern inline function leftShift(bits: Bits, shiftCount: Int): Bits
		return Bits.from(bits.int() << shiftCount);

	@:op(A >> B)
	public static extern inline function rightShift(bits: Bits, shiftCount: Int): Bits
		return Bits.from(bits.int() >> shiftCount);

	@:op(A >>> B)
	public static extern inline function unsignedRightShift(
		bits: Bits,
		shiftCount: Int
	): Bits {
		return Bits.from(bits.int() >>> shiftCount);
	}

	@:op(A == B) public static function equal(a: Bits, b: Bits): Bool;

	@:op(A != B) public static function notEqual(a: Bits, b: Bits): Bool;

	@:op(A & B) public static function and(a: Bits, b: Bits): Bits;

	@:op(A | B) public static function or(a: Bits, b: Bits): Bits;

	@:op(A ^ B) public static function xor(a: Bits, b: Bits): Bits;

	@:op(~A) public static function negate(a: Bits): Bits;

	/**
		Sets the bit at `index`.
		@return New `Bits` value.
	**/
	public static extern inline function set(bits: Bits, index: Int): Bits {
		return bits | (one << index);
	}

	/**
		Unsets the bit at `index`.
		@return New `Bits` value.
	**/
	public static extern inline function unset(bits: Bits, index: Int): Bits {
		return bits & ~(one << index);
	}

	/**
		Zips two bit arrays.
		For consistent behavior, avoid passing values greater than 16 bits.
		@param a Any bit array.
		@param b Any bit array.
	**/
	public static inline function zip(a: Bits, b: Bits): Bits {
		return a.separateBits() | (b.separateBits() << 1);
	}

	public extern inline function new(v: Int) {
		this = v;
	}

	/**
		Casts `this` to `Int`.
	**/
	public extern inline function int(): Int
		return this;

	/**
		@return `true` if the bit at `index` is set.
	**/
	public extern inline function get(index: Int): Bool {
		return new Bits(this) & (one << index) != zero;
	}

	/**
		@return The number of bits in `this` that are set to `true` (or binary one).
	**/
	public inline function countOnes(): Int {
		var n = this;
		n = n - ((n >>> 1) & 0x55555555);
		n = (n & 0x33333333) + ((n >>> 2) & 0x33333333);
		n = (((n + (n >>> 4)) & 0x0F0F0F0F) * 0x01010101) >>> 24;
		return n;
	}

	/**
		Separates each bit of `n` with one unset bit.
		For consistent behavior, avoid calling this on values greater than 16 bits.
	**/
	public inline function separateBits(): Bits {
		var n = this;
		n = (n | (n << 8)) & 0x00ff00ff; // 0000 0000 1111 1111 0000 0000 1111 1111
		n = (n | (n << 4)) & 0x0f0f0f0f; // 0000 1111 0000 1111 0000 1111 0000 1111
		n = (n | (n << 2)) & 0x33333333; // 0011 0011 0011 0011 0011 0011 0011 0011
		n = (n | (n << 1)) & 0x55555555; // 0101 0101 0101 0101 0101 0101 0101 0101
		return Bits.from(n);
	}

	/**
		@param byteCount Number of bytes to be stringified.
		@return `String` representation of `this`, each byte separated with a space.
	**/
	public function stringify(byteCount: UInt): String {
		var buffer = new StringBuffer();
		var bitMask = one << (8 * byteCount - 1);

		for (i in 0...8) {
			buffer.addChar(Bits.from(this) & bitMask != zero ? "1".code : "0".code);
			bitMask >>>= 1;
		}

		for (k in 0...byteCount.int() - 1) {
			buffer.addChar(" ".code);

			for (i in 0...8) {
				buffer.addChar(Bits.from(this) & bitMask != zero ? "1".code : "0".code);
				bitMask >>>= 1;
			}
		}

		return buffer.toString();
	}

	/**
		@return `String` representation (4 bytes).
	**/
	public extern inline function toString(): String {
		return Bits.from(this).stringify(4);
	}
}
