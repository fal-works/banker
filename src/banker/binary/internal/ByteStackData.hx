package banker.binary.internal;

import haxe.Int32;
import haxe.Int64;
import banker.binary.Constants.*;
import banker.binary.internal.BytesData;

abstract ByteStackData(BytesData) from BytesData to BytesData {
	public extern inline function new(byteLength: UInt)
		this = new BytesData(byteLength);

	public extern inline function drop(topPos: UInt, wordSize: WordSize): UInt
		return topPos - wordSize.bytes();

	public extern inline function popI32(topPos: UInt): PopReturn<Int32> {
		topPos -= LEN32;
		return new PopReturn(this.getI32(topPos), topPos);
	}

	public extern inline function popI64(topPos: UInt): PopReturn<Int64> {
		topPos -= LEN64;
		return new PopReturn(this.getI64(topPos), topPos);
	}

	public extern inline function popF32(topPos: UInt): PopReturn<Float32> {
		topPos -= LEN32;
		return new PopReturn(this.getF32(topPos), topPos);
	}

	public extern inline function popF64(topPos: UInt): PopReturn<Float> {
		topPos -= LEN64;
		return new PopReturn(this.getF64(topPos), topPos);
	}

	public extern inline function pushI32(topPos: UInt, v: Int32): UInt {
		this.setI32(topPos, v);
		return topPos + LEN32;
	}

	public extern inline function pushI64(topPos: UInt, v: Int64): UInt {
		this.setI64(topPos, v);
		return topPos + LEN64;
	}

	public extern inline function pushF32(topPos: UInt, v: Float32): UInt {
		this.setF32(topPos, v);
		return topPos + LEN32;
	}

	public extern inline function pushF64(topPos: UInt, v: Float): UInt {
		this.setF64(topPos, v);
		return topPos + LEN64;
	}

	public extern inline function peekI32(topPos: UInt): Int32
		return this.getI32(topPos - LEN32);

	public extern inline function peekI64(topPos: UInt): Int64
		return this.getI64(topPos - LEN64);

	public extern inline function peekF32(topPos: UInt): Float
		return this.getF32(topPos - LEN32);

	public extern inline function peekF64(topPos: UInt): Float
		return this.getF64(topPos - LEN64);

	public extern inline function dup32(topPos: UInt): UInt
		return pushI32(topPos, peekI32(topPos));

	public extern inline function dup64(topPos: UInt): UInt
		return pushF64(topPos, peekF64(topPos));

	public extern inline function swap32(topPos: UInt): Void {
		final pos1 = topPos - LEN32;
		final pos2 = pos1 - LEN32;
		final tmp = this.getI32(pos1); // tmp < pos1
		this.setI32(pos1, this.getI32(pos2)); // pos1 < pos2
		this.setI32(pos2, tmp); // pos2 < tmp
	}

	public extern inline function swap64(topPos: UInt): Void {
		final pos1 = topPos - LEN64;
		final pos2 = pos1 - LEN64;
		final tmp = this.getF64(pos1); // tmp < pos1
		this.setF64(pos1, this.getF64(pos2)); // pos1 < pos2
		this.setF64(pos2, tmp); // pos2 < tmp
	}

	public extern inline function over32(topPos: UInt, topWordSize: WordSize): UInt
		return pushI32(topPos, this.getI32(topPos - topWordSize.bytes() - LEN32));

	public extern inline function over64(topPos: UInt, topWordSize: WordSize): UInt
		return pushF64(topPos, this.getF64(topPos - topWordSize.bytes() - LEN64));
}
