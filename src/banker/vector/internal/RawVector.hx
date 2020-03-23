package banker.vector.internal;

/**
	The body of `RawVector<T>`.

	If HashLink `hl.NativeArray<T>`, otherwise `haxe.ds.Vector<T>`.
**/
#if hl
typedef RawVectorData<T> = hl.NativeArray<T>;
#else
typedef RawVectorData<T> = haxe.ds.Vector<T>;
#end

/**
	Integration of `hl.NativeArray` and `haxe.ds.Vector`.
	Internally used in `banker.vector` package.
**/
#if hl
@:forward(length)
#else
@:forward(length, toArray)
#end
abstract RawVector<T>(RawVectorData<T>) {
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

	static inline function fromData<T>(data: RawVectorData<T>): RawVector<T>
		return cast data;

	var data(get, never): RawVectorData<T>;

	inline function get_data()
		return this;

	public inline function new(length: Int)
		this = new RawVectorData<T>(length);

	@:op([]) public inline function get(index: Int): T
		return this[index];

	@:op([]) public inline function set(index: Int, value: T): T
		return this[index] = value;

	/**
		Copies elements from `src` (beginning at `srcPos`) to `this` (beginning at `pos`).
		@param pos The destination position.
		@param src The source vector.
		@param srcPos The source position.
		@param srcLen The length of the range to be copied.
	**/
	public inline function blit<T>(
		pos: Int,
		src: RawVector<T>,
		srcPos: Int,
		srcLen: Int
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
	public inline function sub<T>(pos: Int, len: Int): RawVector<T> {
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
	public inline function toArray(): Array<T>
		return [for (i in 0...this.length) this[i]];
	#end
}
