package banker.vector.extension;

import banker.common.MathTools;
import banker.array.ArrayTools;

using banker.array.ArrayExtension;

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
		return _this.data.sub(position, length);
	}

	/** @see `subVector()` **/
	public static inline function subVectorWritable<T>(
		_this: VectorReference<T>,
		position: Int,
		length: Int
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
		return _this.data.sub(startPosition, endPosition - startPosition);
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
		final array = ArrayTools.allocate(endPosition - startPosition);

		var readIndex = startPosition;
		var writeIndex = 0;
		while (readIndex < endPosition) {
			array.set(writeIndex, _this[readIndex]);
			++readIndex;
			++writeIndex;
		}

		return array;
	}

	/**
		Copies `this` and also deduplicates values.
		O(n^2) complexity (which is not very good).
		@return New vector with deduplicated values from `this`.
	**/
	public static inline function copyDeduplicated<T>(
		_this: VectorReference<T>
	): Vector<T> {
		final length = _this.length;

		return if (length == 0) copy(_this) else {
			final newVector = new WritableVector(length);

			newVector[0] = _this[0];
			var writeIndex = 1;

			for (readIndex in 1...length) {
				final value = _this[readIndex];
				if (newVector.ref.hasIn(value, 0, writeIndex)) continue;

				newVector[writeIndex] = value;
				++writeIndex;
			}

			slice(newVector, 0, writeIndex);
		}
	}

	/**
		Copies `this` and also deduplicates values.
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

		return if (length == 0) copy(_this) else {
			final newVector = new WritableVector(length);

			newVector[0] = _this[0];
			var writeIndex = 1;

			for (readIndex in 1...length) {
				final value = _this[readIndex];
				if (newVector.ref.hasEqualIn(
					value,
					equalityPredicate,
					0,
					writeIndex
				)) continue;

				newVector[writeIndex] = value;
				++writeIndex;
			}

			slice(newVector, 0, writeIndex);
		}
	}

	/**
		Copies `this` and also deduplicates values.
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
}
