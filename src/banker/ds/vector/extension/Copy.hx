package banker.ds.vector.extension;

@:access(banker.ds.vector.VectorReference)
class Copy {
	/**
		Returns a new concatenated vector.
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function concat<T>(
		_this: VectorReference<T>,
		otherVector: VectorReference<T>
	): VectorReference<T> {
		final thisLength = _this.length;
		final otherLength = otherVector.length;
		final newVector = new WritableVector(thisLength + otherLength);
		// @formatter:off
		VectorTools.blit(_this, 0, newVector, 0, thisLength);
		VectorTools.blit(otherVector, 0, newVector, thisLength, otherLength);
		// @formatter:on
		return newVector;
	}

	/** @see `Copy.concat()` **/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function concatWritable<T>(
		_this: VectorReference<T>,
		otherVector: VectorReference<T>
	): WritableVector<T> {
		return concat(_this, otherVector).writable();
	}

	/** @see `Copy.slice()` **/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function slice<T>(
		_this: VectorReference<T>,
		startPosition: Int,
		endPosition: Int
	): VectorReference<T> {
		return _this.sub(startPosition, endPosition - startPosition);
	}

	/**
		Creates a new vector by slicing `this`.
		@param startPosition The position in `this` to begin (included).
		@param endPosition The position in `this` to end (not included).
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static inline function sliceWritable<T>(
		_this: VectorReference<T>,
		startPosition: Int,
		endPosition: Int
	): WritableVector<T> {
		return slice(_this, startPosition, endPosition).writable();
	}

	/**
		Creates a new array by slicing `this`.
		@param startPosition The position in `this` to begin (included).
		@param endPosition The position in `this` to end (not included).
	**/
	#if !banker_generic_disable
	@:generic
	#end
	public static function sliceToArray<T>(
		_this: VectorReference<T>,
		startPosition: Int,
		endPosition: Int
	): Array<T> {
		return [for (i in startPosition...endPosition) _this[i]];
	}
}
