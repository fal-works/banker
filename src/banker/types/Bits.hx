package banker.types;

import sneaker.string_buffer.StringBuffer;

/**
	Bit array based on `Int`.
**/
abstract Bits(Int) {
	extern public static inline final zero = Bits.from(0);
	extern public static inline final one = Bits.from(1);

	/**
		Casts `Int` to `Bits`.
	**/
	extern public static inline function from(v: Int): Bits
		return new Bits(v);

	@:op(A << B)
	extern public static inline function leftShift(bits: Bits, shiftCount: Int): Bits
		return Bits.from(bits.toInt() << shiftCount);

	@:op(A >> B)
	extern public static inline function rightShift(bits: Bits, shiftCount: Int): Bits
		return Bits.from(bits.toInt() >> shiftCount);

	@:op(A >>> B)
	extern public static inline function unsignedRightShift(
		bits: Bits,
		shiftCount: Int
	): Bits {
		return Bits.from(bits.toInt() >>> shiftCount);
	}

	@:op(A == B) extern public static function equal(a: Bits, b: Bits): Bool;

	@:op(A != B) extern public static function notEqual(a: Bits, b: Bits): Bool;

	@:op(A & B) extern public static function and(a: Bits, b: Bits): Bits;

	@:op(A | B) extern public static function or(a: Bits, b: Bits): Bits;

	@:op(A ^ B) extern public static function xor(a: Bits, b: Bits): Bits;

	@:op(~A) extern public static function negate(a: Bits): Bits;

	/**
		Sets the bit at `index`.
		@return New `Bits` value.
	**/
	public static inline function set(bits: Bits, index: Int): Bits {
		return bits | (one << index);
	}

	/**
		Unsets the bit at `index`.
		@return New `Bits` value.
	**/
	public static inline function unsetBit(bits: Bits, index: Int): Bits {
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

	extern public inline function new(v: Int) {
		this = v;
	}

	/**
		Casts `this` to `Int`.
	**/
	extern public inline function toInt(): Int
		return this;

	/**
		@return `true` if the bit at `index` is set.
	**/
	public inline function get(index: Int): Bool {
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
		@return `String` representation of `this`, each byte separated with a space.
	**/
	public function stringify(byteCount: Int): String {
		var buffer = new StringBuffer();
		var bitMask = one << (8 * byteCount - 1);

		for (i in 0...8) {
			buffer.addChar(Bits.from(this) & bitMask != zero ? "1".code : "0".code);
			bitMask >>>= 1;
		}

		for (k in 0...byteCount - 1) {
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
	public inline function toString(): String {
		return Bits.from(this).stringify(4);
	}
}
