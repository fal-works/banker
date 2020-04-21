package banker.vector.extension;

class Copy {
	/**
		@return Shallow copy of `this`.
	**/
	public static inline function copy<T>(_this: VectorReference<T>): Vector<T> {
		return _this.data.copy();
	}

	/**
		@return Shallow copy of `this`.
	**/
	public static inline function copyWritable<T>(
		_this: VectorReference<T>
	): WritableVector<T> {
		return _this.data.copy();
	}

	/**
		Creates a resized copy.
		@param newLength If this is less than the current length,
		the overflowing data is truncated.
		@return Shallow copy of `this` with `newLength`.
	**/
	public static inline function copyResized<T>(
		_this: VectorReference<T>,
		newLength: UInt
	): Vector<T>
		return copyResizedWritable(_this, newLength).nonWritable();

	/**
		Creates a resized copy.
		@param newLength If this is less than the current length,
		the overflowing data is truncated.
		@return Shallow copy of `this` with `newLength`.
	**/
	public static inline function copyResizedWritable<T>(
		_this: VectorReference<T>,
		newLength: UInt
	): WritableVector<T> {
		final newVector = new WritableVector(newLength);
		VectorTools.blitZero(
			_this,
			newVector,
			UInts.min(_this.length, newLength)
		);
		return newVector;
	}

	/**
		Creates a new vector by shallow-copying a range of `this`.
	**/
	public static inline function subVector<T>(
		_this: VectorReference<T>,
		position: UInt,
		length: UInt
	): Vector<T> {
		return _this.data.sub(position, length);
	}

	/** @see `subVector()` **/
	public static inline function subVectorWritable<T>(
		_this: VectorReference<T>,
		position: UInt,
		length: UInt
	): WritableVector<T> {
		return _this.data.sub(position, length);
	}

	/** @see `concat()` **/
	public static inline function concatWritable<T>(
		_this: VectorReference<T>,
		otherVector: VectorReference<T>
	): WritableVector<T> {
		final thisLength = _this.length;
		final otherLength = otherVector.length;
		final newVector = new WritableVector(thisLength + otherLength);
		// @formatter:off
		VectorTools.blitZero(_this, newVector, thisLength);
		VectorTools.blit(otherVector, UInt.zero, newVector, thisLength, otherLength);
		// @formatter:on
		return newVector;
	}

	/**
		Returns a new concatenated vector.
	**/
	public static inline function concat<T>(
		_this: VectorReference<T>,
		otherVector: VectorReference<T>
	): Vector<T> {
		return concatWritable(_this, otherVector).nonWritable();
	}

	/**
		Creates a new vector by slicing `this`.
		@param startPosition The position in `this` to begin (included).
		@param endPosition The position in `this` to end (not included).
	**/
	public static inline function slice<T>(
		_this: VectorReference<T>,
		startPosition: UInt,
		endPosition: UInt
	): Vector<T> {
		return _this.data.sub(startPosition, endPosition - startPosition);
	}

	/** @see `Copy.slice()` **/
	public static inline function sliceWritable<T>(
		_this: VectorReference<T>,
		startPosition: UInt,
		endPosition: UInt
	): WritableVector<T> {
		return slice(_this, startPosition, endPosition).writable();
	}

	/**
		Creates a new array by slicing `this`.
		@param startPosition The position in `this` to begin (included).
		@param endPosition The position in `this` to end (not included).
	**/
	public static inline function sliceToArray<T>(
		_this: VectorReference<T>,
		startPosition: UInt,
		endPosition: UInt
	): Array<T> {
		final array = Arrays.allocate(endPosition - startPosition);

		var readIndex = startPosition;
		var writeIndex = UInt.zero;
		while (readIndex < endPosition) {
			array[writeIndex] = _this[readIndex];
			++readIndex;
			++writeIndex;
		}

		return array;
	}

	/**
		@return Shallow copy of `this` with values in reversed order.
	**/
	public static inline function copyReversed<T>(
		_this: VectorReference<T>
	): Vector<T> {
		return copyReversedWritable(_this).nonWritable();
	}

	/**
		@return Shallow copy of `this` with values in reversed order.
	**/
	public static inline function copyReversedWritable<T>(
		_this: VectorReference<T>
	): WritableVector<T> {
		final length = _this.length;
		final newVector = new WritableVector(length);

		var readIndex = length;
		var writeIndex = UInt.zero;
		while (!readIndex.isZero()) {
			--readIndex;
			newVector[writeIndex] = _this[readIndex];
			++writeIndex;
		}

		return newVector;
	}

	/**
		Copies `this` and also deduplicates values.
		Elements with smaller indices have more priority.
		O(n^2) complexity (which is not very good).
		@return New vector with deduplicated values from `this`.
	**/
	public static inline function copyDeduplicated<T>(
		_this: VectorReference<T>
	): Vector<T> {
		final length = _this.length;

		return if (length.isZero()) copy(_this) else {
			final newVector = new WritableVector(length);

			newVector[UInt.zero] = _this[UInt.zero];
			var writeIndex = UInt.one;

			for (readIndex in UInt.one...length) {
				final value = _this[u(readIndex)];
				if (newVector.ref.hasIn(value, UInt.zero, writeIndex)) continue;

				newVector[writeIndex] = value;
				++writeIndex;
			}

			slice(newVector, UInt.zero, writeIndex);
		}
	}

	/**
		Copies `this` and also deduplicates values.
		Elements with smaller indices have more priority.
		O(n^2) complexity (which is not very good).
		@return New vector with deduplicated values from `this`.
	**/
	public static inline function copyDeduplicatedWritable<T>(
		_this: VectorReference<T>
	): WritableVector<T> {
		return copyDeduplicated(_this).writable();
	}

	/**
		Copies `this` and also deduplicates values.
		Elements with smaller indices have more priority.
		O(n^2) complexity (which is not very good).
		@param equalityPredicate Function that returns `true` if two given elements
			should be considered as equal.
		@return New vector with deduplicated values from `this`.
	**/
	public static inline function copyDeduplicatedWith<T>(
		_this: VectorReference<T>,
		equalityPredicate: T->T->Bool
	): Vector<T> {
		final length = _this.length;

		return if (length.isZero()) copy(_this) else {
			final newVector = new WritableVector(length);

			newVector[UInt.zero] = _this[UInt.zero];
			var writeIndex = UInt.one;

			for (readIndex in UInt.one...length) {
				final value = _this[u(readIndex)];
				if (newVector.ref.hasEqualIn(
					value,
					equalityPredicate,
					UInt.zero,
					writeIndex
				)) continue;

				newVector[writeIndex] = value;
				++writeIndex;
			}

			slice(newVector, UInt.zero, writeIndex);
		}
	}

	/**
		Copies `this` and also deduplicates values.
		Elements with smaller indices have more priority.
		O(n^2) complexity (which is not very good).
		@param equalityPredicate Function that returns `true` if two given elements
			should be considered as equal.
		@return New vector with deduplicated values from `this`.
	**/
	public static inline function copyDeduplicatedWithWritable<T>(
		_this: VectorReference<T>,
		equalityPredicate: T->T->Bool
	): WritableVector<T> {
		return copyDeduplicatedWith(_this, equalityPredicate).writable();
	}

	@:access(sinker.UInt)
	static extern inline function u(v: Int): UInt {
		return new UInt(v);
	}
}
