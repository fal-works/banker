package banker.vector.extension;

import banker.common.MathTools;

class Copy {
	/**
		@return Shallow copy of `this`.
	**/
	public static inline function copy<T>(_this: VectorReference<T>): Vector<T> {
		return Vector.fromData(_this.data.copy());
	}

	/**
		@return Shallow copy of `this`.
	**/
	public static inline function copyWritable<T>(
		_this: VectorReference<T>
	): WritableVector<T> {
		return WritableVector.fromData(_this.data.copy());
	}

	/**
		Creates a resized copy.
		@param newLength If this is less than the current length,
		the overflowing data is truncated.
		@return Shallow copy of `this` with `newLength`.
	**/
	public static inline function copyResized<T>(
		_this: VectorReference<T>,
		newLength: Int
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
		newLength: Int
	): WritableVector<T> {
		final newVector = new WritableVector(newLength);
		VectorTools.blitZero(
			_this,
			newVector,
			MathTools.minInt(_this.length, newLength)
		);
		return newVector;
	}

	/**
		Creates a new vector by shallow-copying a range of `this`.
	**/
	public static inline function subVector<T>(
		_this: VectorReference<T>,
		position: Int,
		length: Int
	): Vector<T> {
		return Vector.fromData(_this.data.sub(position, length));
	}

	/** @see `subVector()` **/
	public static inline function subVectorWritable<T>(
		_this: VectorReference<T>,
		position: Int,
		length: Int
	): WritableVector<T> {
		return WritableVector.fromData(_this.data.sub(position, length));
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
		VectorTools.blit(_this, 0, newVector, 0, thisLength);
		VectorTools.blit(otherVector, 0, newVector, thisLength, otherLength);
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
		startPosition: Int,
		endPosition: Int
	): Vector<T> {
		return Vector.fromData(_this.data.sub(
			startPosition,
			endPosition - startPosition
		));
	}

	/** @see `Copy.slice()` **/
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
	public static inline function sliceToArray<T>(
		_this: VectorReference<T>,
		startPosition: Int,
		endPosition: Int
	): Array<T> {
		return [for (i in startPosition...endPosition) _this[i]];
	}

	/**
		Copies `this` and also deduplicates values.
		O(n) complexity.
		@return New vector with deduplicated values from `this`.
	**/
	public static inline function copyDeduplicated<T>(
		_this: VectorReference<T>
	): Vector<T> {
		final length = _this.length;

		return if (length == 0) copy(_this) else {
			final newVector = new WritableVector(length);

			newVector[0] = _this[0];
			var newLength = 1;

			for (i in 1...length) {
				final value = _this[i];

				var found = false;
				for (k in 0...newLength) {
					if (value != newVector[k]) continue;
					found = true;
					break;
				}

				if (found) continue;

				newVector[newLength] = value;
				++newLength;
			}

			slice(newVector, 0, newLength);
		}
	}

	/**
		Copies `this` and also deduplicates values.
		O(n) complexity.
		@return New vector with deduplicated values from `this`.
	**/
	public static inline function copyDeduplicatedWritable<T>(
		_this: VectorReference<T>
	): WritableVector<T> {
		return copyDeduplicated(_this).writable();
	}
}
