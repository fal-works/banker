package banker.vector.internal;

/**
	The body of `RawVector<T>`.

	If HashLink `hl.NativeArray<T>`, otherwise `haxe.ds.Vector<T>`.
**/
#if hl
import hl.NativeArray as RawVectorData;
#else
import haxe.ds.Vector as RawVectorData;
#end

/**
	Integration of `hl.NativeArray` and `haxe.ds.Vector`.
	Internally used in `banker.vector` package.
**/
#if !hl
@:forward(toArray)
#end
@:notNull
abstract RawVector<T>(RawVectorData<T>) {
	/**
		@return A dummy vector with zero length.
	**/
	public static extern inline function createZero<T>(): RawVector<T> {
		return new RawVector(0);
	}

	/**
		@return Shallow copy of `array` as `RawVector<T>`.
	**/
	public static inline function fromArrayCopy<T>(array: Array<T>): RawVector<T> {
		#if hl
		final len = array.length;
		final newVector = new RawVector<T>(len);
		var i = 0;
		while (i < len) {
			newVector[i] = array[i];
			++i;
		}
		return newVector;
		#else
		return fromData(RawVectorData.fromArrayCopy(array));
		#end
	}

	static extern inline function fromData<T>(data: RawVectorData<T>): RawVector<T>
		return cast data;

	public var length(get, never): UInt;

	extern inline function get_length()
		return this.length;

	var data(get, never): RawVectorData<T>;

	extern inline function get_data()
		return this;

	public extern inline function new(length: UInt) {
		this = new RawVectorData<T>(length.int());
	}

	@:op([]) public extern inline function get(index: UInt): T
		return this[index];

	@:op([]) public extern inline function set(index: UInt, value: T): T
		return this[index] = value;

	/**
		Copies elements from `src` (beginning at `srcPos`) to `this` (beginning at `pos`).
		@param pos The destination position.
		@param src The source vector.
		@param srcPos The source position.
		@param srcLen The length of the range to be copied.
	**/
	public extern inline function blit<T>(
		pos: UInt,
		src: RawVector<T>,
		srcPos: UInt,
		srcLen: UInt
	): Void {
		#if hl
		this.blit(pos, src.data, srcPos, srcLen);
		#else
		RawVectorData.blit(src.data, srcPos, this, pos, srcLen);
		#end
	}

	/**
		@return Shallow copy of `this`.
	**/
	public inline function copy(): RawVector<T> {
		#if hl
		final len = this.length;
		final newVector = new RawVector<T>(len);
		newVector.data.blit(0, this, 0, len);

		return newVector;
		#else
		return fromData(this.copy());
		#end
	}

	/**
		Creates a new vector by applying function `f` to all elements of `this`.
		@param callback
		@return New vector.
	**/
	public inline function map<S>(f: T->S): RawVector<S> {
		#if hl
		final len = this.length;
		final newVector = new RawVector<S>(len);
		var i = 0;
		while (i < len) {
			newVector[i] = f(this[i]);
			++i;
		}

		return newVector;
		#else
		return fromData(this.map(f));
		#end
	}

	/**
		Creates a sub-vector of `this` by shallow-copying the given range.
		@param pos The position in `this` to begin.
		@param len The length of the range to be copied.
		@return New vector.
	**/
	public inline function sub<T>(pos: UInt, len: UInt): RawVector<T> {
		#if hl
		return fromData(this.sub(pos, len));
		#else
		final subVector = new RawVector<T>(len);
		subVector.blit(0, fromData(this), pos, len);

		return subVector;
		#end
	}

	#if hl
	/**
		@return Shallow copy of `this` as `Array<T>`.
	**/
	public inline function toArray(): Array<T> {
		final array = Arrays.allocate(this.length);
		final len = this.length;
		var i = 0;
		while (i < len) {
			array[i] = this[i];
			++i;
		}
		return array;
	}
	#end
}
