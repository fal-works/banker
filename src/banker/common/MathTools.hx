package banker.common;

class MathTools {
	extern public static inline function minInt(a: Int, b: Int): Int
		return if (a < b) a else b;

	extern public static inline function maxInt(a: Int, b: Int): Int
		return if (a < b) b else a;

	extern public static inline function absoluteInt(n: Int): Int
		return if (0 <= n) n else -n;
}
